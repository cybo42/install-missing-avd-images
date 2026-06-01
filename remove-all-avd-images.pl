#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $delete = 0;
GetOptions("delete|d" => \$delete) or die "Usage: $0 [-d|--delete]\n";

print "Reading installed system images from sdkmanager...\n";

my %installed;
open my $sdk, "-|", "sdkmanager --list" or die "Could not run sdkmanager: $!";
my $in_installed_section = 0;
while (<$sdk>) {
  # The output has an "Installed packages:" section followed by an
  # "Available Packages:" section. We only care about the former.
  if (/^Installed packages:/) {
    $in_installed_section = 1;
    next;
  }
  if (/^Available Packages:/ || /^Available Updates:/) {
    $in_installed_section = 0;
    next;
  }
  next unless $in_installed_section;

  # Lines look like: "  system-images;android-30;google_apis;x86_64 | 12 | ..."
  if (/^\s*(system-images;\S+)/) {
    $installed{$1} = 1;
  }
}
close $sdk;

my @packages = sort keys %installed;

if (!@packages) {
  print "\nNo system-images are installed.\n";
  exit 0;
}

if ($delete) {
  print "\nUninstalling all system-images...\n";
  for my $package (@packages) {
    print "sdkmanager --uninstall '$package'\n";
    system("sdkmanager", "--uninstall", $package) == 0
      or warn "Failed to uninstall $package\n";
  }
} else {
  print "\nThe following system-images would be uninstalled:\n";
  print "$_\n" for @packages;
  print "\nDry run only. Pass -d or --delete to actually uninstall.\n";
}
