{ mkShell
, sops-import-keys-hook
, sops
, deploy-rs
}:

mkShell {
  nativeBuildInputs = [
    deploy-rs
    sops
    sops-import-keys-hook
  ];
}
