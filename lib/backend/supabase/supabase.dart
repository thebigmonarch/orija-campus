import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';
export 'storage/storage.dart';

String _kSupabaseUrl = 'https://dgwvnxdxushgfvuzrvdr.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRnd3ZueGR4dXNoZ2Z2dXpydmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDgwMDQsImV4cCI6MjA4NzQyNDAwNH0.uSYPYWqZN8xrrKeKzRp7ToJ891lbri-Y3Dm0jKEDGVE';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
        headers: {'X-Client-Info': 'flutterflow'},
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
