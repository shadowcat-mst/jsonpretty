package App::JSONPretty;

use strictures 1;
use JSON;
use Try::Tiny;

my $usage = "Usage:
  $0 <filename
  $0 filename
";

sub new_json_object {
  JSON->new->utf8->pretty->relaxed->canonical;
}

sub source_filehandle {
  if (@ARGV) {
    open my $fh, '<', $ARGV[0]
      or die "Couldn't open $ARGV[0]: $!";
    $fh;
  } else {
    *STDIN;
  }
}

sub source_data {
  my $src = source_filehandle;
  do { local $/; <$src> }
    or die "No source data supplied\n${usage}"
}

sub run {
  my $json = new_json_object;

  my $src_data = source_data;

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
