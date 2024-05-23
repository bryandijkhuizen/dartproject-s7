#!/bin/bash

# Get the values from the environment variables
SUPABASE_URL=$1
SUPABASE_ANON_KEY=$2

# Create the JSON content
cat <<EOF > ./Frontend/config.json
{
  "SUPABASE_URL": "$SUPABASE_URL",
  "SUPABASE_ANON_KEY": "$SUPABASE_ANON_KEY"
}
EOF
