#!/usr/bin/perl
use feature 'unicode_strings';
use utf8;


use strict;
use Path::Class;
use autodie; # die if problem reading or writing a file

open(F, '>:encoding(UTF-8)', 'entreprises.html');

my $dir = dir("."); # /tmp
my $file = $dir->file("entreprises.html"); # /tmp/file.txt
# Get a file_handle (IO::File object) you can write to
my $file_handle = $file->openw();

open(F, '<:encoding(UTF-8)', 'corpus.txt');
my @list1=<F>;
my $total = @list1;
print $total,"\n";
close(F);

my $line_num = 1;

print "Début de la conversion\n";

# Prepare file
$file_handle->print("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"fr\" lang=\"fr\">");
$file_handle->print("<head>");
$file_handle->print("	<title>Annuaires entreprises</title>");
$file_handle->print("	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />");
$file_handle->print("	<meta http-equiv=\"Content-Language\" content=\"fr\" />");
$file_handle->print("	<meta name=\"description\" content=\"Page présentant les entreprises.\" />");
$file_handle->print("	<meta name=\"keywords\" content=\"Entreprises\" />");
$file_handle->print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"parcour.css\">");
$file_handle->print("</head><body>");
$file_handle->print("<div class=\"contenu\">");
$file_handle->print("<div class=\"colonne\">");
$file_handle->print("<h1>Listes des entreprises</h1>");
$file_handle->print("<ul>");

my @entreprises = ();

foreach my $line (@list1){
	
   	print $line_num . "/" . $total ."\n";
	if ($line=~/{EXPERIENCE}/){
 		my @fields = split(/,/, $line);
		my $field = @fields[2];
		if (!$field eq ""){
			$field = "\L$field";
	        my $html = "<li>CONTENU: </li>";
	        
	        if (($field ne "-") && !($field ~~ @entreprises)){
	        	push(@entreprises, $field);
				$html =~ s/(CONTENU)/$field/g;
				$html =~ s/://g;
				$file_handle->print($html . "\n");   
	        }
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
print "Conversion terminée\n";