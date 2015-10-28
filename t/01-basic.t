use Test;
use Attribute::SetOnce;
use v6;

class A { has $.foo is set-once }

{
    my $a = A.new;
    is($a.foo, Any, 'before set');
    $a.foo = 123;
    is($a.foo, 123, 'after 1st set');
    { $a.foo = 456;
      CATCH { default { like(~$_,rx/^Cannot\sre\-set/,'re-set fail'); } } }
    is($a.foo, 123, 'after 2nd set');
}

{
    my $a = A.new;
    is($a.foo, Any, 'before set');
    $a.foo = $a.foo but Attribute::SetOnce::IsSet;
    is($a.foo, Any but Attribute::SetOnce::IsSet, 'after 1st "set" on type obj');
    { $a.foo = 456;
      CATCH { default { like(~$_,rx/^Cannot\sre\-set/,'re-set fail'); } } }
    ok($a.foo ~~ Any:U, 'after 2nd set');
}

done-testing;

# vim:ft=perl6
