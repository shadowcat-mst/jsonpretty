package App::JSONPretty;

use strictures 1;
use JSON;
use Try::Tiny;

sub run {

  my $usage = "Usage:
    $0 <filename
    $0 filename
  ";

  my $json = JSON->new->utf8->pretty->relaxed->canonical;

  my $src = @ARGV
    ? do {
        open my $fh, '<', $ARGV[0]
          or die "Couldn't open $ARGV[0]: $!";
        $fh;
      }
    : \*STDIN;

  my $src_data = do { local $/; <$src> };

  die "No source data supplied\n${usage}"
    unless $src_data;

  my $data_structure = try {
    $json->decode($src_data)
  } catch {
    die "Error parsing JSON: $_\n";
  };

  my $output = try {
    $json->encode($data_structure)
  } catch {
    die "Error generating JSON: $_\n";
  };

  print $output;

  return 0;

}

exit run unless caller;

1;
