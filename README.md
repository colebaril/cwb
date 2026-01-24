
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cwb

<!-- badges: start -->

<!-- badges: end -->

The `cwb` package is a personal library of functions, ggplot2 themes,
and palettes that I reach for often in data analysis and visualization.
Instead of re-writing code across projects, I can now use my favorite
utilities directly from this package.

## Installation

You can install the development version of cwb from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("colebaril/cwb")
```

## Example

### Themes and Palettes

In the following example, `theme_parchment()` is used to alter thematic
elements of the plot and `scale_spellbook()` is used to apply my custom
colour palettes. I also use the `add_caption_cwb()` function to
automatically insert a caption that is pre-formatted with icons and
social media tags.

``` r
require(pacman)
p_load(cwb, tidyverse, palmerpenguins, extrafont)


ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
  geom_point(shape = 21) +
  geom_smooth(aes(colour = species), se = FALSE, method = "lm") +
  scale_cwb(name = "Species", palette = "arcane_flame", type = "d", aesthetics = "fill") +
  scale_cwb(name = "Species", palette = "arcane_flame", type = "d", aesthetics = "colour") +
  theme_parchment() +
  labs(title = "Palmer Penguin Bill Length \nvs. Flipper Length", x = "Flipper Length (mm)", y = "Bill Length (mm)") +
  add_caption_cwb(type = "plot") 
```

<img src="man/figures/README-example_theme_palette-1.png" width="100%" />

### Data Cleaning

In this example, `clean_data()` is used to standardize column names,
trim white space, convert empty columns to true `NA`s, and flags
outliers for any numeric columns using robust means.

``` r
df <- tibble::tibble(
  "First Name" = c(" Alice ", "Bob", "", "CHARLIE", "dave", "Eve", NA, "Bob", "Bob"),
  "Last Name" = c("Smith", "Jones", "O'Neil", "Brown", "Miller", "O'Brien", "", "Jones", "Jones"),
  "Score" = c(10, 5000, 15, 20, 12, -999, 14, 5000, 5000),  
  "Enrollment Date" = c("2025-01-01", "20241215", "2025/02/01", "", NA, "01-03-2025", "2025-01-01", "2024-12-15", "2024-12-15"),
  "Grade" = c("A", "b", "C", "A", "B", "", "A", "b", "b"),
  "Comments!" = c("Good", " Excellent ", "", "Needs work", NA, "Good!", "Average", " Excellent ", " Excellent "),
  "EmptyCol" = c(NA, NA, NA, NA, NA, NA, NA, NA, NA)
)

print(df)
#> # A tibble: 9 × 7
#>   `First Name` `Last Name` Score `Enrollment Date` Grade `Comments!`   EmptyCol
#>   <chr>        <chr>       <dbl> <chr>             <chr> <chr>         <lgl>   
#> 1 " Alice "    "Smith"        10 "2025-01-01"      "A"   "Good"        NA      
#> 2 "Bob"        "Jones"      5000 "20241215"        "b"   " Excellent " NA      
#> 3 ""           "O'Neil"       15 "2025/02/01"      "C"   ""            NA      
#> 4 "CHARLIE"    "Brown"        20 ""                "A"   "Needs work"  NA      
#> 5 "dave"       "Miller"       12  <NA>             "B"    <NA>         NA      
#> 6 "Eve"        "O'Brien"    -999 "01-03-2025"      ""    "Good!"       NA      
#> 7  <NA>        ""             14 "2025-01-01"      "A"   "Average"     NA      
#> 8 "Bob"        "Jones"      5000 "2024-12-15"      "b"   " Excellent " NA      
#> 9 "Bob"        "Jones"      5000 "2024-12-15"      "b"   " Excellent " NA

clean_data(df, trim_chars = TRUE, empty_to_na = TRUE, flag_outliers = TRUE)
#> # A tibble: 8 × 8
#>   first_name last_name score enrollment_date grade comments   empty_col
#>   <chr>      <chr>     <dbl> <chr>           <chr> <chr>      <lgl>    
#> 1 Alice      Smith        10 2025-01-01      A     Good       NA       
#> 2 Bob        Jones      5000 20241215        b     Excellent  NA       
#> 3 <NA>       O'Neil       15 2025/02/01      C     <NA>       NA       
#> 4 CHARLIE    Brown        20 <NA>            A     Needs work NA       
#> 5 dave       Miller       12 <NA>            B     <NA>       NA       
#> 6 Eve        O'Brien    -999 01-03-2025      <NA>  Good!      NA       
#> 7 <NA>       <NA>         14 2025-01-01      A     Average    NA       
#> 8 Bob        Jones      5000 2024-12-15      b     Excellent  NA       
#> # ℹ 1 more variable: score_outlier_flag <lgl>
```

### Citing Packages

Using the `cwb::cite_packages()` function, you can easily cite all
packages used in your script or file, choosing between R Markdown output
or plain text options.

``` r
cite_packages(format = "rmd")
```

1.  Chang W (2023). *extrafont: Tools for Using Fonts*.
    <doi:10.32614/CRAN.package.extrafont>
    <https://doi.org/10.32614/CRAN.package.extrafont>, R package version
    0.19, <https://CRAN.R-project.org/package=extrafont>.

2.  Horst AM, Hill AP, Gorman KB (2020). *palmerpenguins: Palmer
    Archipelago (Antarctica) penguin data*. <doi:10.5281/zenodo.3960218>
    <https://doi.org/10.5281/zenodo.3960218>, R package version 0.1.0,
    <https://allisonhorst.github.io/palmerpenguins/>.

3.  Grolemund G, Wickham H (2011). “Dates and Times Made Easy with
    lubridate.” *Journal of Statistical Software*, *40*(3), 1-25.
    <https://www.jstatsoft.org/v40/i03/>.

4.  Wickham H (2023). *forcats: Tools for Working with Categorical
    Variables (Factors)*. <doi:10.32614/CRAN.package.forcats>
    <https://doi.org/10.32614/CRAN.package.forcats>, R package version
    1.0.0, <https://CRAN.R-project.org/package=forcats>.

5.  Wickham H (2023). *stringr: Simple, Consistent Wrappers for Common
    String Operations*. <doi:10.32614/CRAN.package.stringr>
    <https://doi.org/10.32614/CRAN.package.stringr>, R package version
    1.5.1, <https://CRAN.R-project.org/package=stringr>.

6.  Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr:
    A Grammar of Data Manipulation*. <doi:10.32614/CRAN.package.dplyr>
    <https://doi.org/10.32614/CRAN.package.dplyr>, R package version
    1.1.4, <https://CRAN.R-project.org/package=dplyr>.

7.  Wickham H, Henry L (2025). *purrr: Functional Programming Tools*.
    <doi:10.32614/CRAN.package.purrr>
    <https://doi.org/10.32614/CRAN.package.purrr>, R package version
    1.0.4, <https://CRAN.R-project.org/package=purrr>.

8.  Wickham H, Hester J, Bryan J (2024). *readr: Read Rectangular Text
    Data*. <doi:10.32614/CRAN.package.readr>
    <https://doi.org/10.32614/CRAN.package.readr>, R package version
    2.1.5, <https://CRAN.R-project.org/package=readr>.

9.  Wickham H, Vaughan D, Girlich M (2024). *tidyr: Tidy Messy Data*.
    <doi:10.32614/CRAN.package.tidyr>
    <https://doi.org/10.32614/CRAN.package.tidyr>, R package version
    1.3.1, <https://CRAN.R-project.org/package=tidyr>.

10. Müller K, Wickham H (2023). *tibble: Simple Data Frames*.
    <doi:10.32614/CRAN.package.tibble>
    <https://doi.org/10.32614/CRAN.package.tibble>, R package version
    3.2.1, <https://CRAN.R-project.org/package=tibble>.

11. Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*.
    Springer-Verlag New York. ISBN 978-3-319-24277-4,
    <https://ggplot2.tidyverse.org>.

12. Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
    Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller
    E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V,
    Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to
    the tidyverse.” *Journal of Open Source Software*, *4*(43), 1686.
    <doi:10.21105/joss.01686> <https://doi.org/10.21105/joss.01686>.

13. Baril C (2026). *cwb: Cole’s personal collection of R functions,
    themes, and palettes.*. R package version 0.0.0.9000, commit
    f685a138aaaeb35fd415e2a8f3d5edc0dc7f01d8,
    <https://github.com/colebaril/cwb>.

14. Rinker TW, Kurkiewicz D (2018). *pacman: Package Management for R*.
    version 0.5.0, <http://github.com/trinker/pacman>.
