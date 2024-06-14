abstract class Constants {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wofmpmokrotlntuqjptl.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndvZm1wbW9rcm90bG50dXFqcHRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI5MTUwMjcsImV4cCI6MjAyODQ5MTAyN30.7hTbaWkxDQ-lKctP6wICrQiuPA1AwJrEFgYdVztkSdE',
  );
}
