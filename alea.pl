#!/usr/bin/perl
use feature 'unicode_strings';
use utf8;


use strict;
use Path::Class;
use autodie; # die if problem reading or writing a file

open(F, '>:encoding(UTF-8)', 'alea.html');

my $dir = dir("."); # /tmp
my $file = $dir->file("alea.html"); # /tmp/file.txt
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
$file_handle->print("	<title>Etudiant aléatoire</title>");
$file_handle->print("	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />");
$file_handle->print("	<meta http-equiv=\"Content-Language\" content=\"fr\" />");
$file_handle->print("	<meta name=\"description\" content=\"Page présentant aléatoirement un des diplômés des formations de l'université Charles de Gaulle.\" />");
$file_handle->print("	<meta name=\"keywords\" content=\"Aléatoire Lille 3\" />");
$file_handle->print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"parcours.css\">");
$file_handle->print("</head><body>");
$file_handle->print("<div class=\"contenu\">");
$file_handle->print("<div class=\"colonne\">");
$file_handle->print("<h1>A la une, aléatoirement</h1>");
$file_handle->print("<ul>");

my $random = int(rand($total));
my $flag_writting = 0;
foreach my $line (@list1){
	if ($line_num >= $random){
	   	if ($line=~/{PERSONNE}/){
	   		if ($flag_writting == 0){
	   			print $line_num . "/" . $total . " fw " . $flag_writting ."\n";
				$flag_writting = 1;
		    	my @pers_line = split(/{PERSONNE}/, $line);
		    	my @infos_pers = split(/,/, $pers_line[1]);
		    	# print "Chez " . $infos_pers[0] . "\n";
		    	$file_handle->print("<li class=\"personne\"><div class=\"name\"><a class=\"interne\" href=\"#\" >".$infos_pers[0]."</a><span class=\"formation\">" . $infos_pers[1] . "" . $infos_pers[2] . "</span></div>\n");
    			$file_handle->print("<h2>Expériences\ professionnelles<\/h2>");
	    	}elsif($flag_writting == 1){
	    		$flag_writting = -1;
	    	}
	    }elsif ($line=~/{EXPERIENCE}/ && $flag_writting == 1){
			
	 		my @fields = split(/,/, $line);
	 		my $field_id = 0;
	    	foreach my $fields_words (@fields) {
	    		my @checkclosing = (3, 8);

				if (!$fields_words eq ""){

			        my $intitule = "CONTENU</span></div>";
					my $unk = "<div class=\"sous-intitule\">CONTENU</div>";
			        my $entreprise = "<div><div class=\"entreprise\">CONTENU: </strong>";
			        my $site = "<a href=\"CONTENU\">CONTENU</a></div>";
			        my $formation = "<div class=\"formation-entreprise\">CONTENU</div>";
			        #my $promotion = "<p><span class=\"promotion\">CONTENU</span></p>";
			        #my $secteur = "<p><strong>CONTENU</strong></div>";
			        my $unk2 = "<div>CONTENU</div>";
			        my $ville = "<div><span>CONTENU</span>";
			        my $cp = "<span>CONTENU</span>";
			        my $dep = "<span>CONTENU</span></div>";
			        my $unk3 = "<div>CONTENU</div>";
			        my $type = "<div><span>CONTENU</span></div>";
			        my $contrat = "<div>CONTENU</div>";
			        my $deb = "<div><span class=\"date\">Date de début: </span><span>CONTENU</span></div>";
			        my $fin = "<div><span class=\"date\">Date de fin: </span><span>CONTENU</span></div>";


			        my @pattern = ($intitule, $unk, $entreprise, $site, $formation, $unk2, $ville, $cp, $dep, $unk3, $type, $contrat, $deb, $fin);
					my @name = ("intitule", "unk", "entreprise", "site", "formation", "unk2", "ville", "cp", "dep", "unk3", "type", "contrat", "deb", "fin");
						
					$fields_words =~ s/{EXPERIENCE}/<div class=\"experience\"><span class=\"poste\">/g;
					my $html = @pattern[$field_id];
			        
			        if ($fields_words ne "-"){
			        	
						$html =~ s/(CONTENU)/$fields_words/g;
						
						$file_handle->print($html . "\n");
				        
			        }else {
						$html =~ s/(CONTENU)//g;
						$file_handle->print($html . "\n");
			        }
			        
		        }
				$field_id++;
	    	}
	    	
	    }elsif ($flag_writting == 1){
			$file_handle->print("<div class=\"explication\">" . $line . "</div>\n");
	    }
	}
    $line_num++;

}
$file_handle->print("\n</li>");

$file_handle->print("</ul>");
$file_handle->print("</div>");
$file_handle->print("<hr/>");
$file_handle->print("</div>");
$file_handle->print("<div class=\"pied\"></div>");
$file_handle->print("</body></html>");
print "Conversion terminée\n";