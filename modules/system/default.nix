{
  shell = import ./shell.nix;
  services = import ./services;
  desktop = import ./desktop;
  dev = import ./dev;
}
