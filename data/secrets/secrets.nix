let
  anchor = "";
  all_recipients = [anchor];
in {
  # network
  "network/beeconnected.age".publicKeys = all_recipients;

  # common
  "common/gpg.age".publicKeys = all_recipients;
}
