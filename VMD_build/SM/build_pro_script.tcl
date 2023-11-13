package require psfgen
set toppar toppar_psfgen
topology $toppar/top_all36_prot.rtf
topology $toppar/toppar_water_ions.str
pdbalias residue HIS HSD
pdbalias atom ILE CD1 CD

foreach ch {A B} {
	segment PRO$ch { pdb seg/PRO$ch.pdb 
	auto angles dihedrals}
	coordpdb seg/PRO$ch.pdb PRO$ch
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
	coordpdb seg/HET$ch.pdb HET$ch
}

foreach ch {A B} {
        segment LSM$ch {
                first NONE
                last NONE
                pdb seg/LSM$ch.pdb
                auto angles dihedrals
                }
        coordpdb seg/LSM$ch.pdb LSM$ch
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
	coordpdb seg/MOD_WAT$seg.pdb WAT$seg
}


writepsf PRO_MEMB_WAT.psf
writepdb PRO_MEMB_WAT.pdb

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
