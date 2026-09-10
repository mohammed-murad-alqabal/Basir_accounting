export 'inventory_connection_stub.dart'
    if (dart.library.ffi) 'inventory_connection_native.dart'
    if (dart.library.js_interop) 'inventory_connection_web.dart';
