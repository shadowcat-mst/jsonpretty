use strictures 1;
use Test::More;
use App::JSONPretty;

sub run_test {
  my ($in) = @_;
  my $out;
  local (*STDIN, *STDOUT);
  open STDIN, '<', \$in;
  open STDOUT, '>', \$out;
  App::JSONPretty::run();
  $out;
}

is(
  run_test('{ "foo": 1, "bar": 2, }'),
  q'{
   "bar" : 2,
   "foo" : 1
}
',
  "Output ok (simple test)"
);

done_testing;
