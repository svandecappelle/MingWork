#!/usr/bin/perl
use feature 'unicode_strings';
use utf8;


use strict;
use Path::Class;
use autodie; # die if problem reading or writing a file

open(F, '>:encoding(UTF-8)', 'parcours.html');

my $dir = dir("."); # /tmp
my $file = $dir->file("parcours.html"); # /tmp/file.txt
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
	
   	print $line_num . "/" . $total ."\n";
	if ($line=~/{PERSONNE}/){
    	my @pers_line = split(/{PERSONNE}/, $line);
    	my @infos_pers = split(/,/, $pers_line[1]);
    	# print "Chez " . $infos_pers[0] . "\n";
    	$file_handle->print("<li><a class=\"interne\" href=\"#\" >".$infos_pers[0]."</a><span class=\"STYLE1\">" . $infos_pers[1] . "" . $infos_pers[2] . "</li>\n");
    	$file_handle->print("<p>Expériences\ professionnelles<\/p>");
    }elsif ($line=~/{EXPERIENCE}/){
		
 		my @fields = split(/,/, $line);
 		my $field_id = 0;
    	foreach my $fields_words (@fields) {
    		my @checkclosing = (3, 8);

			if (!$fields_words eq ""){
				
				#print "# " . $field_id . " = " . $fields_words . "\n";
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

		        my $intitule = "CONTENU</span></p>";
				my $unk = "<p>CONTENU</p>";
		        my $entreprise = "<div><strong>CONTENU: </strong>";
		        my $site = "<a href=\"CONTENU\">CONTENU</a></div>";
		        my $formation = "<p><span class=\"formation\">CONTENU</span></p>";
		        #my $promotion = "<p><span class=\"promotion\">CONTENU</span></p>";
		        #my $secteur = "<p><strong>CONTENU</strong></div>";
		        my $unk2 = "<p>CONTENU</p>";
		        my $ville = "<div><span>CONTENU</span>";
		        my $cp = "<span>CONTENU</span>";
		        my $dep = "<span>CONTENU</span></div>";
		        my $unk3 = "<p>CONTENU</p>";
		        my $type = "<div><span>CONTENU</span></div>";
		        my $contrat = "<div>CONTENU</div>";
		        my $deb = "<div><span>Date de début: </span><span>CONTENU</span></div>";
		        my $fin = "<div><span>Date de fin: </span><span>CONTENU</span></div>";


		        my @pattern = ($intitule, $unk, $entreprise, $site, $formation, $unk2, $ville, $cp, $dep, $unk3, $type, $contrat, $deb, $fin);
				my @name = ("intitule", "unk", "entreprise", "site", "formation", "unk2", "ville", "cp", "dep", "unk3", "type", "contrat", "deb", "fin");
					
				$fields_words =~ s/{EXPERIENCE}/<p><span class=\"petitetiquette\">/g;
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
    	
    }else{
		$file_handle->print("<div>" . $line . "</div>\n");
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