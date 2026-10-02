(() => {
  let port;
  const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
  const result = (ok, message, extra = {}) => JSON.stringify({ok, message, ...extra});

  window.sanctumSerialConnect = async () => {
    if (!('serial' in navigator)) {
      return result(false, 'Web Serial is not available in this browser. Use a supported desktop Chromium browser over HTTPS.');
    }
    try {
      // requestPort must run directly from a user click; the chooser is intentional.
      port = await navigator.serial.requestPort();
      await port.open({baudRate: 115200});
      await delay(1200);
      const info = port.getInfo();
      return result(true, 'Serial port connected. Waiting for Sanctum IQ diagnostics protocol.', {
        vendorId: info.usbVendorId ?? null,
        productId: info.usbProductId ?? null,
      });
    } catch (error) {
      port = undefined;
      return result(false, error?.name === 'NotFoundError'
        ? 'No port was selected.'
        : `Could not connect: ${error?.message ?? error}`);
    }
  };

  window.sanctumSerialReconnect = async () => {
    if (!('serial' in navigator)) return result(false, 'Web Serial is not available in this browser.');
    try {
      const ports = await navigator.serial.getPorts();
      if (ports.length !== 1) return result(false, 'No previously authorized Arduino port is available. Use Connect Arduino to select one.');
      port = ports[0];
      if (!port.readable) {
        await port.open({baudRate: 115200});
        await delay(1200);
      }
      return result(true, 'Previously authorized Arduino detected and connected.');
    } catch (error) {
      port = undefined;
      return result(false, `Could not reopen Arduino: ${error?.message ?? error}`);
    }
  };

  window.sanctumSerialDiagnose = async () => {
    if (!port?.readable || !port?.writable) return result(false, 'Connect an Arduino first.');
    let writer;
    let reader;
    try {
      writer = port.writable.getWriter();
      await writer.write(new TextEncoder().encode('{"protocol":"sanctum-iq/1","command":"diagnostics"}\n'));
      writer.releaseLock();
      writer = undefined;
      reader = port.readable.getReader();
      const decoder = new TextDecoder();
      let buffer = '';
      const timeout = Date.now() + 6000;
      while (Date.now() < timeout) {
        const read = await Promise.race([
          reader.read(),
          delay(timeout - Date.now()).then(() => ({timedOut: true})),
        ]);
        if (read.timedOut) {
          await reader.cancel();
          reader.releaseLock();
          reader = undefined;
          await port.close();
          await port.open({baudRate: 115200});
          return result(false, 'Arduino connected, but no diagnostic response arrived before timeout.');
        }
        if (read.done) break;
        buffer += decoder.decode(read.value, {stream: true});
        while (buffer.includes('\n')) {
          const newline = buffer.indexOf('\n');
          const line = buffer.slice(0, newline).trim();
          buffer = buffer.slice(newline + 1);
          if (!line) continue;
          let report;
          try { report = JSON.parse(line); } catch (_) { continue; }
          if (report.protocol === 'sanctum-iq/1' && report.components && typeof report.components === 'object') {
            return result(true, 'Diagnostic report received.', {report});
          }
        }
      }
      return result(false, 'Arduino connected, but no supported diagnostic report arrived. The current firmware may not implement sanctum-iq/1.');
    } catch (error) {
      return result(false, `Diagnostic communication failed: ${error?.message ?? error}`);
    } finally {
      try { writer?.releaseLock(); } catch (_) {}
      try { reader?.releaseLock(); } catch (_) {}
    }
  };

  window.sanctumSerialDisconnect = async () => {
    if (!port) return;
    try { await port.close(); } finally { port = undefined; }
  };
})();
