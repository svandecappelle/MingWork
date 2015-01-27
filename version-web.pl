#!/usr/bin/perl
use feature 'unicode_strings';
use utf8;

binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

use strict;
use Path::Class;
use autodie; # die if problem reading or writing a file

my $dir = dir("."); # /tmp
my $file = $dir->file("parcours.html"); # /tmp/file.txt
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


# Prepare file
$file_handle->print("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"fr\" lang=\"fr\">");
$file_handle->print("<head>");
$file_handle->print("	<title>Annuaires etudiants</title>");
$file_handle->print("	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />");
$file_handle->print("	<meta http-equiv=\"Content-Language\" content=\"fr\" />");
$file_handle->print("	<meta name=\"description\" content=\"Page présentant les annuaires des diplômés des formations de l'université Charles de Gaulle.\" />");
$file_handle->print("	<meta name=\"keywords\" content=\"Annuaires Lille 3\" />");
$file_handle->print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"parcour.css\">");
$file_handle->print("</head><body>");
$file_handle->print("<div class=\"contenu\">");
$file_handle->print("<div class=\"colonne\">");
$file_handle->print("<ul>");

foreach my $line (@list1){

	print "line: " . $line_num ."\n";
    if ($line=~/{PERSONNE}/){
    	my @pers_line = split(/{PERSONNE}/, $line);
    	my @infos_pers = split(/,/, $pers_line[1]);
    	print "Chez " . $infos_pers[0] . "\n";
    	$file_handle->print("<li><a class=\"interne\" href=\"#\" >".$infos_pers[0]."</a><span class=\"STYLE1\">" . $infos_pers[1] . "" . $infos_pers[2] . "</li>\n");
    }elsif ($line=~/{EXPERIENCE}/){
 		my @fields = split(/,/, $line);
 		my $field_id = 0;
    	foreach my $fields_words (@fields) {
    		#print "words field; " . $fields_words . " id: " . $field_id . "\n";
	        # 0: Intitule
	        # 1: ?
	        # 2: Entreprise
	        # 3: www
	        # 4: Secteur
	        # 5: ?
	        # 6: Ville
	        # 7: CP
	        # 8: Departement
	        # 9: ?
	        # 10: Type
	        # 11: Contrat
	        # 12: Date Debut
	        # 13: Date fin

	        my @pattern = ("<p>CONTENU</p>", "<p><span class=\"formation\">CONTENU</span></p>", "<p><span class=\"promotion\">CONTENU</span></p>", "<p><strong>CONTENU</strong></p>", "", "", "", "", "", "", "", "", "", "" );

	        if ($field_id ~~ [0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13]){
	        	#print "words field; " . $field_id . "\n";
	        	#print "data: " . $data1[0] . "\n";
				#$fields_words
	        }

	        $field_id++;
    	}

    }
    $line_num++;

}
$file_handle->print("</ul>");
$file_handle->print("</div>");
$file_handle->print("<hr/>");
$file_handle->print("</div>");
$file_handle->print("<div class=\"pied\"></div>");
$file_handle->print("</body></html>");
