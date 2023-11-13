package require psfgen
set toppar toppar_psfgen
topology $toppar/top_all36_prot.rtf
topology $toppar/toppar_water_ions.str
pdbalias residue HIS HSD
pdbalias atom ILE CD1 CD

foreach ch {A B} {
	segment PRO$ch { pdb seg/PRO$ch.pdb 
	auto angles dihedrals}
	coordpdb seg/PROch.pdbPROch.pdb PROch
}


topology $toppar/top_all36_lipid.rtf
topology $toppar/toppar_all36_lipid_sphingo.str
topology $toppar/top_all36_carb.rtf
topology $toppar/top_all36_cgenff.rtf

foreach ch {C D} {
	segment HET$ch {
		first NONE
		last NONE
		pdb seg/HET$ch.pdb
		auto angles dihedrals
		}
	coordpdb seg/HETch.pdbHETch.pdb HETch
}

foreach ch {A B} {
        segment LPAF$ch {
                first NONE
                last NONE
                pdb seg/LPAF_$ch.pdb
                auto angles dihedrals
                }
        coordpdb seg/LPAF_ch.pdbLPAFch.pdb LPAFch
}

guesscoord

writepsf PRO.psf
writepdb PRO.pdb


segment MEMB {
first NONE
last NONE
pdb seg/MEMB.pdb
auto angles dihedrals
}
coordpdb seg/MEMB.pdb MEMB


writepsf PRO_MEMB.psf
writepdb PRO_MEMB.pdb


foreach seg {1 2 3 4 5 6} {
	segment WAT$seg {
	first NONE
	last NONE
	pdb seg/MOD_WAT$seg.pdb
	auto angles dihedrals
	}
	coordpdb seg/MOD_WATseg.pdbWATseg.pdb WATseg
}


writepsf PRO_MEMB_WAT.psf
writepdb PRO_MEMB_WAT.pdb

#topology $toppar/toppar_water_ions_tip5p.str
segment MG {
first NONE
last NONE
pdb seg/MG.pdb
auto angles dihedrals
}
coordpdb seg/MG.pdb MG

segment CLA {
first NONE
last NONE
pdb seg/CLA.pdb
auto angles dihedrals
}
coordpdb seg/CLA.pdb CLA
guesscoord

writepsf PRO_MEMB_WAT_ION.psf
writepdb PRO_MEMB_WAT_ION.pdb

quit
