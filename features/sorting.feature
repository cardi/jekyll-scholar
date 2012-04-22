Feature: Sorting BibTeX Bibliographies
  As a scholar who likes to blog
  I want to sort my bibliographies according to configurable parameters

	Scenario Outline: Sort Bibliography
		Given I have a configuration file with "citation_sort_order" set to "<sort-by>"
	  And I have a page "references.bib":
			"""
			---
			---
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2008},
			  publisher = {O'Reilly Media}
			}
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2007},
			  publisher = {O'Reilly Media}
			}
			"""
	  When I run jekyll
    Then "<pattern-1>" should come before "<pattern-2>" in "_site/references.html"

  Scenarios: Various Sort Orders
    | sort-by    | pattern-1 | pattern-2 |
    | none       | 2008      | 2007      |
    | year       | 2007      | 2008      |
      