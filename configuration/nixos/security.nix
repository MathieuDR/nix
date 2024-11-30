{
  self,
  hostname,
  ...
}: {
  # local caddy certificate
  security.pki.certificates = [
    # HPI Certificate
    (builtins.readFile "${self}/data/secrets/certificates/hpi_ca.crt")
  ];

  age.identityPaths = ["/etc/${hostname}/agenix_${hostname}_system"];
}
