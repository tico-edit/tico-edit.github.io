#!/usr/bin/env perl

use strict;
use warnings;
use XOR;

my $xor = XOR->new(
  root => '.',
  org  => 'tico-edit',
  site_name => 'tico',
);

$xor->builder->build;
