# Results File

The results file contains the search results together with the search
input parameters and MS data. This means that a results file contains
everything necessary to generate a report, repeat the search at a later
date, or act as the self-contained input file to a project database or LIMS.
The contents are divided into logical sections:

1. Search parameters
2. Mass values
3. Quantitation method (if used)
4. Unimod extract
5. Enzyme definition
6. Taxonomy (if a taxonomy filter was used)
7. Misc. header information
8. Summary results (for Protein Summary)
9. Mixtures (if PMF)
10. Summary of decoy results (if automatic decoy)
11. Summary of error tolerant results (if automatic ET)
12. Mixtures in decoy results (if automatic decoy PMF)
13. Peptides (if SQ or MIS)
14. Decoy peptides (if SQ or MIS and automatic ET)
15. Error tolerant peptides (if SQ or MIS and automatic ET)
16. Proteins (if SQ or MIS)
17. Query data, one block for each query
18. Index

### General Notes

1. Values are shown in italics
2. Scripts are written so that label case doesn’t matter.
3. Labels are used to assist readability, but kept short to minimise
file size
4. Parameters are grouped logically
5. Order of blocks is not important except that the index block
must be the last block. Presence of blank lines within the index
block may cause a problem.
6. Because the MIME type is defined as an unknown application,
if this file passes through a mail agent, it will be treated as an
“octet stream” and encoded “base64” for transmission.

## Search parameters

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”parameters”

    USERNAME=user name in plain text
    USEREMAIL=email address in plain text
    SEARCH=PMF
    COM=search title text
    DB=MSDB
    CLE=Trypsin
    MASS=Monoisotopic
    MODS=Mod 1,Mod 2
    .
    .
    .
    RULES=1,2,5,6,8,9,13,14
    --gc0p4Jq0M2Yt08jU534c0p

The Parameters section contains the complete set of parameter values
from the search form apart from the contents of the uploaded data file or
the query window. Labels must be unique, independent of case. Where a
parameter can be multivalued (e.g. mods) the values are listed on one
line separated by commas.
RULES contains a list of the rule numbers that define the instrument
type in the configuration file fragmentation_rules. The rule numbers
are listed explicitly because the contents of the configuration file may
have changed since the search was run.

## Masses

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”masses”

    A=71.037110
    B=114.534940
    C=160.030649
    D=115.026940
    E=129.042590
    F=147.068410
    G=57.021460
    H=137.058910
    I=113.084060
    J=0.000000
    K=128.094960
    L=113.084060
    M=131.040480
    N=114.042930
    O=0.000000
    P=97.052760
    Q=128.058580
    R=156.101110
    S=87.032030
    T=101.047680
    U=150.953630
    V=99.068410
    W=186.079310
    X=111.000000
    Y=163.063330
    Z=128.550590
    Hydrogen=1.007825
    Carbon=12.000000
    Nitrogen=14.003074
    Oxygen=15.994915
    Electron=0.000549
    C_term=17.002740
    N_term=1.007825
    delta1=15.994919,Oxidation (M)
    NeutralLoss1=0.000000
    FixedMod1=57.021469, Carbamidomethyl (C)
    FixedModResidues1=C
    --gc0p4Jq0M2Yt08jU534c0p

This block contains “actual” mass values. That is, average or monisotopic
residue masses, including any fixed modifications; C and N terminus
groups also include any fixed modifications.

FixedMod1, FixedMod2, etc., records the delta mass and name for each
fixed modification as comma separated values. FixedModResidues1 gives
the site specificity. If multiple residues are affected, they are listed as a
string, e.g. STY. If there was a neutral loss, the delta mass is given by
the value of FixedModNeutralLoss1.

    FixedModn=delta, Name
    FixedModResiduesn=[A-Z]|C_term|N_term
    FixedModNeutralLossn=mass

Fixed modifications cannot have peptide neutral losses, multiple neutral
losses and cannot be protein-terminal or residue-terminal. In all these
cases, fixed modifications are automatically converted into variable ones.

Variable modifications are reported in delta1, delta2, etc. Each entry
defines the difference in mass introduced by the modification together
with the name of the modification, separated by a comma. If a variable
modification suffers a neutral loss on fragmentation, the delta is speci-
fied by a NeutralLossn entry. By definition, this is always a master
neutral loss. If there are multiple neutral losses, then two more lines
appear:

    NeutralLossn_master=mass[[,mass] ...]
    NeutralLossn_slave=mass[[,mass] ...]

The first neutral loss (defined by NeutralLossn) has an implicit index
number of 1. Any additional neutral losses (defined by
NeutralLossn_master or followed by NeutralLossn_slave) have implicit
index numbers of 2 and up.

If a modification includes a required or optional neutral loss from the
precursor, this is recorded as follows:

    ReqPepNeutralLossn=mass[[,mass] ...]
    PepNeutralLossn=mass[[,mass] ...]

Error-tolerant modifications are not listed in masses section.

## Quantitation

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”quantitation”

    <?xml version=”1.0" encoding=”UTF-8" standalone=”no” ?>
    <quantitation majorVersion=”1" minorVersion=”0" xmlns=”http://
    www.matrixscience.com/xmlns/schema/quantitation_1" xmlns:xsi=
    “http://www.w3.org/2001/XMLSchema-instance” xsi:schemaLocation=”http:/
    /www.matrixscience.com/xmlns/schema/quantitation_1 qu
    antitation_1.xsd”>
    <method constrain_search=”false” description=”15N metabolic label-
    ling” min_num_peptides=”2" name=”15N Metabolic [MD]” pro
    t_score_type=”mudpit” protein_ratio_type=”weighted”
    report_detail=”true” require_bold_red=”true” show_sub_sets=”0.5"
    sig_th
    reshold_value=”0.05">
    <component name=”light”>
    <isotope/>
    </component>
    <component name=”heavy”>
    <isotope>
    <old>N</old>
    <new>15N</new>
    </isotope>

This section is an extract from quantitation.xml containing the
quantitation method specified for the search. For more details and a link
to the schema, refer to the Mascot HTML help pages for quantitation.

## Unimod

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”unimod”

    <?xml version=”1.0" encoding=”UTF-8" standalone=”no” ?>
    <umod:unimod xmlns:umod=”http://www.unimod.org/xmlns/schema/unimod_2"
    majorVersion=”2" minorVersion=”0" xmlns:xsi=”http://w
    ww.w3.org/2001/XMLSchema-instance” xsi:schemaLocation=”http://
    www.unimod.org/xmlns/schema/unimod_2 unimod_2.xsd”>
    <umod:elements>
    <umod:elem avge_mass=”1.00794" full_name=”Hydrogen”
    mono_mass=”1.007825035" title=”H”/>
    <umod:elem avge_mass=”2.014101779" full_name=”Deuterium”
    mono_mass=”2.014101779" title=”2H”/>
    <umod:elem avge_mass=”6.941" full_name=”Lithium”
    mono_mass=”7.016003" title=”Li”/>
    <umod:elem avge_mass=”12.0107" full_name=”Carbon” mono_mass=”12"
    title=”C”/>

This section is an extract from unimod.xml containing data for the
elements, amino_acids, and any modifications specified in the search
form. For more details and a link to the schema, refer to the help pages
at www.unimod.org

## Enzyme

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”enzyme”

    Title:Trypsin
    Cleavage:KR
    Restrict:P
    Cterm
    *

This section is simply an extract from the enzyme file. Syntax details can
be found in Chapter 6

## Taxonomy

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”taxonomy”

    Title:. . . . . . . . . . . . . . . . Homo sapiens (human)
    Include: 9606
    Exclude:
    *

This section is simply an extract from the taxonomy file. Syntax details
can be found in Chapter 9

## Header

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”header”

    sequences=number of sequences in DB
    sequences_after_tax=number of sequences after taxonomy filter
    residues=number of residues in DB
    distribution=see below
    exec_time=search time in seconds
    date=timestamp (seconds since Jan 1st 1970)
    time=time in hh:mm:ss
    queries=number of queries, (>= 1)
    max_hits=maximum number of hits to be listed
    version=version information
    fastafile=full path to database fasta file
    release=filename of actual database used - e.g. Owl_31.fasta
    taskid=unique task identifier for searches submitted asynchronously
    pmf_num_queries_used=number of mass values selected for PMF match
    pmf_queries_used=comma separated list of selected query numbers
    Warn0=
    Warn1=
    Warn2=
    --gc0p4Jq0M2Yt08jU534c0p

The Header section contains general values, used in the master results
page header paragraph.
Distribution is a comma separated list of values that represent a
histogram of the complete protein score distribution. The first value is
the number of entries with score 0, the second is the number of entries
with score 1, and so on, up to the maximum score for the search. Scores
are converted to integers by truncation. This distribution is only mean-
ingful for a peptide mass fingerprint search.
If intensity values are supplied for a peptide mass fingerprint, Mascot
iterates the experimental peaks to find the set that gives the best score.
The number of values selected is reported in pmf_num_queries_used
and the selected queries listed in pmf_queries_used.

## Summary results

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”summary”

    qmass1=Mr
    qexp1=m/z for query 1,
    charge
    qintensity1=intensity value for query1 (if available)
    qmatch1=Total number of peptide mass matches for query1 in database
    qplughole1=Threshold score for homologous peptide match (MIS only)
    qmass2=...
    qexp2=...
    qintensity1=
    qmatch2=...
    qplughole2=...
    .
    .
    .
    qmassn=...
    qexpn=...
    qintensityn=
    qmatchn=...
    qplugholen=...
    num_hits=number of hits in the summary block (<= max_hits)
    h1=accession string,
        total protein score,
        obsolete,
        intact protein mass
    h1_text=title text
    h1_frame=frame_number (between 1 and 6, for nucleic acid only)
    h1_q1=missed cleavages, (–1 indicates no match)
        peptide Mr,
        delta,
        start,
        end,
        number of ions matched,
        peptide string,
        peaks used from Ions1,
        variable modifications string,
        ions score,
        multiplicity,
        ion series found,
        peaks used from Ions2,
        peaks used from Ions3,
        total area of matched peaks
    h1_q1_et_mods=modification mass,
        neutral loss mass,
        modification description
    h1_q1_et_mods_master=neutral loss mass[[,neutral loss mass] ... ]
    h1_q1_et_mods_slave=neutral loss mass[[,neutral loss mass] ... ]
    h1_q1_primary_nl=neutral loss string
    h1_q1_na_diff=original NA sequence,
        modified NA sequence
    h1_q1_tag=tagNum:startPos:endPos:seriesID,...
    h1_q1_drange=startPos:endPos
    h1_q1_terms=residue,residue
    h1_q1_subst=pos1,ambig1,matched1 ... ,posn,ambign,matchedn
    h1_q2=...
    .
    .
    .
    h1_qm=...
    h2=...
    .
    .
    .
    hn_qm=...
    --gc0p4Jq0M2Yt08jU534c0p

Where a parameter has multiple values, these are shown on separate
lines for clarity. In the actual result file, all values for a parameter are
on a single line and there are no spaces or tabs between values.
Variable modifications is a string of digits, one digit for the N terminus,
one for each residue and one for the C terminus. Each digit specifies the
modification used to obtain the match: 0 indicates no modification, 1
indicates delta1, 2 indicates delta2 etc., in the masses section. If the
number of modifications exceeds 9, the letters A to W are used to repre-
sent modifications 10 to 32. X is used to indicate a modification found in
error tolerant mode.
neutral loss string is the same concept as the variable mod string,
except each character represents the index of the primary neutral loss
(one of the master NL). Any position that is not modified, or where the
mod has no neutral loss, is set to 0. hn_qm_primary_nl will only be
output if the string contains at least one non-zero character.
If a new modification is found in an error tolerant search, its position is
marked by X, and details are recorded in an additional entry,
hn_qm_et_mods. If the error tolerant search is of a nucleic acid data-
base, and the modification is a single base change in the primary se-
quence, the two mass fields will be set to zero, and one of the keywords
NA_INSERTION, NA_DELETION, or NA_SUBSTITUTION will appear in the
description field. The additional parameter hn_qm_na_diff is then used
to record the ‘before’ and ‘after’ nucleic acid sequences.
*Ion series* is a string of 19 digits representing the ion series:

    a
    place holder
    a++
    b
    place holder
    b++
    y
    place holder
    y++
    c
    c++
    x
    x++
    z
    z++
    z+H
    z+H++
    z+2H
    z+2H++

A digit is set to 1 if the corresponding series contains more than just
random matches and 2 if the series contributes to the score.
Multiplicity means number of peptide mass matches for a query in a
protein
For each sequence tag, four colon separated values are output: 1-based
tag number, 1-based residue position where tag starts, 1-based residue
position where tag ends, ion series into which the tag was matched:

    -1 means no matches for the tag
    0 “a” series (single charge)
    1 “a-NH3” series (single charge)
    2 “a” series (double charge)
    3 “b” series (single charge)
    4 “b-NH3” series (single charge)
    5 “b” series (double charge)
    6 “y” series (single charge)
    7 “y-NH3” series (single charge)
    8 “y” series (double charge)
    9 “c” series (single charge)
    10 “c” series (double charge)
    11 “x” series (single charge)
    12 “x” series (double charge)
    13 “z” series (single charge)
    14 “z” series (double charge)
    15 “a-H2O” series (single charge)
    16 “a-H2O” series (double charge)
    17 “b-H2O” series (single charge)
    18 “b-H2O” series (double charge)
    19 “y-H2O” series (single charge)
    20 “y-H2O” series (double charge)
    21 “a-NH3” series (double charge)
    22 “b-NH3” series (double charge)
    23 “y-NH3” series (double charge)
    25 “internal yb” series (single charge)
    26 “internal ya” series (single charge)
    27 “z+H” series (single charge)
    28 “z+H” series (double charge)
    29 high-energy “d” and “d’” series (single charge)
    31 high-energy “v” series (single charge)
    32 high-energy “w” and “w’” series (single charge)
    33 “z+2H” series (single charge)
    34 “z+2H” series (double charge)

If there are multiple tags for a query, comma separated groups of these
numbers are output for each tag.
hn_qm_drange is output for a query that includes an error tolerant
sequence tag. It defines the range of positions within which an unsus-
pected modification has been located. For a peptide of 10 residues,
position 0 would indicate the amino terminus and position 11 would
indicate the carboxy terminus. If there is no location information, the
range is output as 0,256

hn_qm_terms shows the residues the bracket the peptide in the protein.
If the peptide forms the terminus of the protein, then a hyphen is used
instead.

hn_qm_subst is output when the matched peptide contained an ambigu-
ous residue, (B, X, or Z). The argument is one or more triplets of comma
separated values. For each triplet, the first value is the residue position,
the second is the ambiguous residue, and the third is the residue that
has been substituted to obtain the reported match.

For a large MS/MS search, num_hits is set to zero, and the summary
block only contains entries for qmassn, qexpn, qmatchn,
qplugholen. The threshold for switching to this mode is specified using
two parameters in the Options section of mascot.dat. SplitDataFileSize
is the size of the search process in bytes, (default 10000000), and
SplitNumberOfQueries is the size of the search in queries, (default
1000).

If this is a two-pass search, either an automatic decoy database search or
an automatic error tolerant search, a second summary block appears,
containing the second set of results. The section name is either
et_summary or decoy_summary. The syntax of the contents is identical

## Mixture

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”mixture”

    num_hits=number of mixtures found
    h1_score=total score for mixture 1
    h1_numprot=number of proteins in mixture 1
    h1_nummatch=number of queries matched
    h1_m1=accession string for protein component 1
    h1_m2=accession string for protein component 2
    .
    .
    .
    h1_mm=accession string for protein component m
    h2_score=
    .
    .
    .
    hn_mm=
    --gc0p4Jq0M2Yt08jU534c0p

The Mixture section is only output for a peptide mass fingerprint. If any
statistically significant protein mixtures are found, the mixture compo-
nents are summarised. For details of individual components, use the
accession strings to refer back to the Summary section.

If this is an automatic decoy database search, a second mixture block
appears, containing the second set of results. The section name is
decoy_mixture. The syntax of the contents is identical

## Peptides

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”peptides”

    q1_p1=missed cleavages, (–1 indicates no match)
        peptide Mr,
        delta,
        number of ions matched,
        peptide string,
        peaks used from Ions1,
        variable modifications string,
        ions score,
        ion series found,
        peaks used from Ions2,
        peaks used from Ions3;
        “accession string”: data for first protein
            frame number:
            start:
            end:
            multiplicity,
        “accession string”: data for second protein
            frame number:
            start:
            end:
            multiplicity,
        etc.
    q1_p1_et_mods=modification mass,
        neutral loss mass,
        modification description
    q1_p1_et_mods_master=neutral loss mass[[,neutral loss mass] ... ]
    q1_p1_et_mods_slave=neutral loss mass[[,neutral loss mass] ... ]
    q1_p1_primary_nl=neutral loss string
    q1_p1_na_diff=original NA sequence,
        modified NA sequence
    q1_p1_tag=tagNum:startPos:endPos:seriesID,...
    q1_p1_drange=startPos:endPos
    q1_p1_terms=residue,residue[[:residue,residue] ... ]
    q1_p1_subst=pos1,ambig1,matched1 ... ,posn,ambign,matchedn
    q1_p1_comp=quantitation component name
    q1_p2=...
    .
    .
    .
    qn_pm=...
    --gc0p4Jq0M2Yt08jU534c0p

Each line contains the data for a peptide match followed by data for at
least one protein in which the peptide was found.

If there multiple entries in the database containing the matched peptide,
there will be a corresponding number of pairs of bracketing residues
listed in qn_pm_terms.

Otherwise, individual field descriptions are identical to those for the
Summary section

If this is a two-pass search, either an automatic decoy database search or
an automatic error tolerant search, a second peptides block appears,
containing the second set of results. The section name is either
et_peptides or decoy_peptides. The syntax of the contents is identical

## Proteins

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”proteins”

    “accession string”=protein mass,
    “title text”
    .
    .
    .
    “accession string”=protein mass,
    “title text”
    --gc0p4Jq0M2Yt08jU534c0p

This block contains reference data for the proteins listed in the peptides
block.

## Input data for query n

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”queryn”

    title=query title
    index=query index
    seq1=sequence qualifier (e.g. N-ABCDEF)
    seq2=...
    .
    .
    .
    seqn=
    comp1=composition qualifier (e.g. 0[P]2[W])
    comp2=...
    .
    .
    .
    compn=...
    PepTol=peptide tolerance qualifier (e.g. 2.000000,Da)
    IT_MODS=Mod 1[,Mod 2[,...]]
    INSTRUMENT=instrument identifier, (e.g. ESI-TRAP)
    RULES=1,2,5,6,8,9,13,14
    INTERNALS=min mass,max mass
    CHARGE=charge state (e.g. 2+)
    RTINSECONDS=a[[-b][,c[-d]]]
    SCANS=a[[-b][,c[-d]]]
    tag1=sequence tag (e.g. t,889.4,[QK]S,1104.54)
    .
    .
    .
    tagn=...
    mass_min=lowest mass
    mass_max=highest mass
    int_min=lowest intensity
    int_max=highest intensity
    num_vals=number of mass values
    num_used1=-1 (obsolete)
    ions1=1344.65:34.3,1365.41:13.2
    ions2=y-1344.65:34.3,1365.41:13.2
    ions3=b-1344.65:34.3,1365.41:13.2
    --gc0p4Jq0M2Yt08jU534c0p

Value “queryn” runs from “query1” (no leading zeros). ionsn values are
sorted so that the matched values come first.

Most searches will only require a few of these fields. For example, a
peptide mass fingerprint would only include the charge field.

The index is a 0 based record of the original query order before sorting by
Mr

ions2 and ions3 are only required when fragment ions are specified in a
sequence query as being N-terminal or C-terminal series.
The first field in a tagn value is t for a standard sequence tag and e for
an error tolerant sequence tag

Some search parameters can be define in the local scope of a query.
These are CHARGE, COMP, INSTRUMENT, IT_MODS, TOL, TOLU.
Any that are used are listed here. If the MGF file contained scan range
information in terms of seconds or scans, this is written to
RTINSECONDS and/or SCANS.

## Index

    --gc0p4Jq0M2Yt08jU534c0p
    Content-Type: application/x-Mascot; name=”index”

    parameters=4
    masses=78
    unimod=116
    enzyme=322
    taxonomy=329
    header=336
    summary=351
    et_summary=6059
    peptides=6473
    et_peptides=7143
    proteins=7292
    query1=7362
    query2=7374.
    .
    .
    .
    query81=8322
    query82=8334
    --gc0p4Jq0M2Yt08jU534c0p--

Values in index are the line number offsets of the section “Content-
Type:” lines (starting from 0 for the first line of the file).

