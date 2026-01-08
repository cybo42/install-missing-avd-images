#!/usr/bin/env perl

my @files = glob("*/config.ini");

foreach $file (@files) {
  print "$file\n";
  my $systemImagePath;
  my $systemImagePackage;
  open(CONFIG, "<$file") || die "Could not open $file:$1";
  while(<CONFIG>){
    $systemImagePath = $1 if /image.sysdir.1=(.*)\//
  }
  close(CONFIG);
  if ($systemImagePath) {
    $systemImagePackage = $systemImagePath;
    $systemImagePackage =~ s/\//;/g;
  }
  # image.sysdir.1

  print "Path $systemImagePackage\n";
  system("sdkmanager '$systemImagePackage'");
  
}

