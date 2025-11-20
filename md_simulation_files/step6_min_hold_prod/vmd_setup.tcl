# Tube representation for residues 100 to end - SF
mol delrep 0 0
mol representation Tube
mol color ColorID 10
mol selection "(resid 101 to 107) or (resid 426 to 432) or (resid 751 to 757) or (resid 1076 to 1082)"
mol material Opaque
mol addrep 0

# Licorice for residues 138 to 463 - HBC
mol representation Licorice
mol color ColorID 8
mol selection "resid 139 464 789 1114"
mol material Opaque
mol addrep 0

# Licorice for residues 265 to 1240 - Upper Gloop 
mol representation Licorice
mol color ColorID 7
mol selection "resid 266 591 916 1241"
mol material Opaque
mol addrep 0

# Licorice for residues 259 to 1234 - Lower Gloop 
mol representation Licorice
mol color ColorID 11
mol selection "resid 260 585 910 1235"
mol material Opaque
mol addrep 0

# Licorice for residues 98 to 423 - GLU
mol representation Licorice
mol color ColorID 4
mol selection "resid 99 424 749 1074"
mol material Opaque
mol addrep 0

# Licorice for residues 130 to 455 - ASN
mol representation Licorice
mol color ColorID 1
mol selection "resid 131 456 781 1106"
mol material Opaque
mol addrep 0

# VDW for potassium ions
mol representation VDW
mol color ColorID 9
mol selection "resname 'K+' 'K'"
mol material Opaque
mol addrep 0
