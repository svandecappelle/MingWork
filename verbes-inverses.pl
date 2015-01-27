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
my $file = $dir->file("inverses.html"); # /tmp/file.txt
# Get a file_handle (IO::File object) you can write to
my $file_handle = $file->openw();

print "length: ". length(@dictionnaire) ."\n";
print "dict: ". @dictionnaire[0] . "\n";

print "Démarrage du scan...\n";
# 4
foreach my $word (@dictionnaire){
	# 5
	if ( $word=~/(.+)(er)$/ || $word=~/(.+)(ir)$/ || $word=~/(.+)(oir)$/ || $word=~/(.+)(re)$/){
		my $prefixe_word = $word;
		
		# 6 ???
		# ajouter les autres préfixes: $word=~/^préfixe/
		if ( $word=~/^dé/){
			#print "avec pref " . $word . "\n";
			$word =~ s/(^dé)//g;
			#print "sans pref " . $word . "\n";
			if ($word ~~ @dictionnaire){
				#print "C'est un verbe préfixé\n";
				#print $prefixe_word . " -> " . $word ."\n";
				$file_handle->print("<div>".$prefixe_word."</div>\n");
			}
		}
	}
}

print "Fin du scan...\n";