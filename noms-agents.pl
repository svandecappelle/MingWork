#!/usr/bin/perl
use strict;
use Path::Class;

use feature 'unicode_strings';
use utf8;

binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

open(F, '<:encoding(UTF8)', 'dictionnaire.txt');
my @dictionnaire=<F>;
close(F);

my $dir = dir("."); # /tmp
my $file = $dir->file("agents.html"); # /tmp/file.txt
# Get a file_handle (IO::File object) you can write to
my $file_handle = $file->openw();

print "length: ". length(@dictionnaire) ."\n";
print "dict: ". @dictionnaire[0] . "\n";

print "Démarrage du scan...\n";
chomp(@dictionnaire);
# 4
foreach my $word (@dictionnaire){
	# 5
	if ( $word=~/(.+)(eur)$/){
		my $agent = $word;
		# 6 ???
		$word =~ s/(eur$)//g;
		chomp $word;
		my @terminaison_possibles = ("er", "ir", "oir", "re");
		foreach my $terminaison (@terminaison_possibles){

			my $verbe_test = join "", $word , $terminaison;	
			if ($verbe_test ~~ @dictionnaire){
				print "agent " . $agent . " --> " . $verbe_test . "\n";
				$file_handle->print("<div>".$agent."</div>\n");
			}
		}

	}
}

print "Fin du scan...\n";