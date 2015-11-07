#!/usr/bin/perl

# Safeness:
use strict;
use warnings;

# DB Module:
use DBI;

# How far we want to go back:
my $i = 30;
my $c = 1;

# Connect to our DB:
my $dbh = DBI->connect('DBI:mysql:amarok', 'root', 'password') || die "Could not connect to DB: $DBI::errstr";

# Prepare and fire off query:
my $query = "SELECT album.name, artist.name AS 'artistname', tags.album FROM album, artist, tags WHERE tags.album = album.id AND tags.artist = artist.id GROUP BY album.id DESC LIMIT $i";
my $sqlQuery = $dbh->prepare($query);
$sqlQuery->execute();

print "\nLast $i Acquired Albums ::\n\n";
while ( my $row = $sqlQuery->fetchrow_hashref() ) {
	if ( $c < 10 ) {
		print "$c  :: $row->{name} - ";
	} else {
		print "$c :: $row->{name} - ";
	}
	#print "Artist: $row->{artistname}\n";
	print "$row->{artistname}\n";

	if ( $c % 10 == 0 ) {
		print "\n";
	}

	$c = $c + 1;
}
print "\n";
