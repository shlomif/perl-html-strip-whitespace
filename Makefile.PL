use 5.004;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'HTML::Strip::Whitespace',
    VERSION_FROM      => 'lib/HTML/Strip/Whitespace.pm', # finds $VERSION
    PREREQ_PM         => 
    {
        'Test::More' => 0,
        'HTML::TokeParser::Simple' => "3.13",
    }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/HTML/Strip/Whitespace.pm', # retrieve abstract from module
       AUTHOR         => 'Shlomi Fish <shlomif@iglu.org.il>') : ()),
);
