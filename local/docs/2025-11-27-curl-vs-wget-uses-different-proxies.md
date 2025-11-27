# 2025-11-27: Curl vs Wget Uses Different CA Trusts on macOS

## Issue
After setting up mitmproxy and trusting its CA certificate in the macOS Keychain (using `security add-trusted-cert`), HTTPS requests work for some tools but not others.

- **Works**: Tools using macOS SecureTransport (e.g., Safari, system `curl`) trust the keychain.
- **Fails**: Tools using OpenSSL (e.g., Homebrew `wget`) ignore the keychain and use their own CA bundle, resulting in certificate verification errors.

## Example
```bash
# After trusting mitmproxy CA in keychain
curl https://example.com  # Works
wget https://example.com  # ERROR: cannot verify certificate
```

## Solution
1. **Add to macOS System Keychain** (for SecureTransport-based tools):
   ```bash
   sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /Users/lamnt45/git/xdgg/exp/xdgg/mm/conf_dir/mitmproxy-ca-cert.pem
   ```

2. **Add to OpenSSL CA Bundle** (for OpenSSL-based tools like Homebrew `wget`):
   - Find OpenSSL directory:
     ```bash
     openssl version -d  # Outputs: OPENSSLDIR: "/opt/homebrew/etc/openssl@3"
     ```
   - Copy the CA cert and update hashes:
     ```bash
     sudo cp /Users/lamnt45/git/xdgg/exp/xdgg/mm/conf_dir/mitmproxy-ca-cert.pem /opt/homebrew/etc/openssl@3/certs/
     sudo c_rehash /opt/homebrew/etc/openssl@3/certs/
     ```

3. **Test**:
   ```bash
   wget https://example.com  # Now works without --no-check-certificate
   ```

## Notes
- For Python requests and Node.js, set `REQUESTS_CA_BUNDLE` and `NODE_EXTRA_CA_CERTS` to the CA PEM file in your proxy setup function.
- This ensures consistent certificate trust across tools when using mitmproxy.