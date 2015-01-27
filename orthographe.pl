#!/usr/bin/perl
use feature 'unicode_strings';
use utf8;

binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

use strict;
use Path::Class;
use autodie; # die if problem reading or writing a file
use List::MoreUtils qw(any);

my $dir = dir("."); # /tmp
my $file = $dir->file("fautes.html"); # /tmp/file.txt
# Get a file_handle (IO::File object) you can write to
my $file_handle = $file->openw();

open(F, '<:encoding(UTF8)', 'corpus.txt');
my @list1=<F>;
close(F);
open(F, '<:encoding(UTF8)', 'dictionnaire.txt');
my @list2=<F>;
close(F);
chomp(@list1,@list2);
my $line_num = 1;
foreach my $line (@list1){

	print "line: " . $line_num ."\n";
    if ($line=~/{PERSONNE}/){
    	my @pers_line = split(/{PERSONNE}/, $line);
    	my @infos_pers = split(/,/, $pers_line[1]);
    	print "Chez " . $infos_pers[0] . "\n";
    	$file_handle->print("<h1>Chez ".$infos_pers[0]."</h1>\n");
    }else{
 		my @fields = split(/,/, $line);
 		my $field_id = 0;
    	foreach my $fields_words (@fields) {
    		#print "words field; " . $fields_words . " id: " . $field_id . "\n";
	        if ($field_id ~~ [0, 1, 2, 4, 5, 8, 9, 10]){
	        	#print "words field; " . $field_id . "\n";
	        	my @cur_field_words = split(/[\ \:\-'\(\)\.\*\[\]\+\_\-\/\"]/, $fields_words);
		        foreach my $word (@cur_field_words) {
		        	#print "data: " . $data1[0] . "\n";
		        	if (length($word)>1){
			        	$word =~ s/({EXPERIENCE})*([0-9]*)*//g;
			        	$word = "\L$word";
			        	#print "word: " . $word . "\n";
			        	my $hit_regex = /$word/;
			        	#print "test: " . $word . "\n";
			        	if ( $word ~~ @list2){
			        		#print " [+] Found: " . $hit_regex . " in dictionnary \n";
			        	}else { 
			        		print "line: " . $line_num . " [x] Unknown: " . $word . "\n";
			        		$file_handle->print("<div><span>Ligne: ".$line_num." </span><span>".$word."</span></div>\n");
			        	}
		        	}
		        }
	        }

	        $field_id++;
    	}

    }
    $line_num++;

}

