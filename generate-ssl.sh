#!/bin/bash

# SSL Certificate Setup Script
# Choose one of the following methods:

echo "SSL Certificate Setup for api.sciprax.com and admin.sciprax.com"
echo "=================================================================="

# Method 1: Self-Signed Certificates (for development/testing)
echo "Method 1: Generating Self-Signed Certificates..."

# Create SSL directory
mkdir -p services/predefined/nginx/ssl

# Generate private key
openssl genrsa -out services/predefined/nginx/ssl/main.key 2048

# Generate certificate signing request (CSR) with both domains
openssl req -new -key services/predefined/nginx/ssl/main.key -out services/predefined/nginx/ssl/main.csr -config <(
cat <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
C=US
ST=State
L=City
O=Organization
CN=api.sciprax.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = api.sciprax.com
DNS.2 = admin.sciprax.com
DNS.3 = *.sciprax.com
EOF
)

# Generate self-signed certificate valid for 365 days
openssl x509 -req -in services/predefined/nginx/ssl/main.csr -signkey services/predefined/nginx/ssl/main.key -out services/predefined/nginx/ssl/main.crt -days 365 -extensions v3_req -extfile <(
cat <<EOF
[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = api.sciprax.com
DNS.2 = admin.sciprax.com
DNS.3 = *.sciprax.com
EOF
)

# Clean up CSR file
rm services/predefined/nginx/ssl/main.csr

echo "Self-signed certificates generated successfully!"
echo "Files created:"
echo "- services/predefined/nginx/ssl/main.key (private key)"
echo "- services/predefined/nginx/ssl/main.crt (certificate)"

echo ""
echo "⚠️  IMPORTANT: For self-signed certificates, you'll need to:"
echo "1. Add entries to your /etc/hosts file (see below)"
echo "2. Accept the security warning in your browser"
echo ""

# Method 2: Let's Encrypt with Certbot (for production)
echo "=================================================================="
echo "Method 2: Let's Encrypt Certificates (Production)"
echo "=================================================================="
echo ""
echo "For production, use Let's Encrypt with the following steps:"
echo ""
echo "1. Install Certbot:"
echo "   sudo apt-get update"
echo "   sudo apt-get install certbot python3-certbot-nginx"
echo ""
echo "2. Stop your current containers:"
echo "   docker-compose down"
echo ""
echo "3. Generate certificates (make sure ports 80/443 are available):"
echo "   sudo certbot certonly --standalone -d api.sciprax.com -d admin.sciprax.com"
echo ""
echo "4. Copy certificates to your project:"
echo "   sudo cp /etc/letsencrypt/live/api.sciprax.com/fullchain.pem services/predefined/nginx/ssl/main.crt"
echo "   sudo cp /etc/letsencrypt/live/api.sciprax.com/privkey.pem services/predefined/nginx/ssl/main.key"
echo ""
echo "5. Set proper permissions:"
echo "   sudo chmod 644 services/predefined/nginx/ssl/main.crt"
echo "   sudo chmod 600 services/predefined/nginx/ssl/main.key"
echo ""
echo "6. Start your containers:"
echo "   docker-compose up -d"
echo ""

echo "=================================================================="
echo "Hosts File Configuration (for development with self-signed certs)"
echo "=================================================================="
echo ""
echo "Add these lines to your /etc/hosts file (Linux/Mac) or C:\Windows\System32\drivers\etc\hosts (Windows):"
echo ""
echo "127.0.0.1 api.sciprax.com"
echo "127.0.0.1 admin.sciprax.com"
echo ""

echo "=================================================================="
echo "Next Steps:"
echo "=================================================================="
echo "1. Run this script to generate certificates"
echo "2. Update your hosts file (for development)"
echo "3. Fix the nginx configuration file"
echo "4. Start your containers: docker-compose up -d"
echo "5. Access your applications:"
echo "   - Main App: https://api.sciprax.com"
echo "   - Admin App: https://admin.sciprax.com"