#!/bin/bash -e
#
# TODO: update to account for testnet/mainnet values in contract
#
############################################################
# Copies clarity contracts to test directory and filters
# out references to mainet contracts
# must be run before > clarinet test
############################################################
pwd
cd ~/hubgit/radicle-solutions/stacks-builders/stacks-sbtc/sbtc-mini-devnet
infile=../sbtc-mini/contracts
outfile=contracts
m1In="'SP000000000000000000002Q6VF78.pox-2"
m1Out="'ST000000000000000000002AMW42H.pox-2"
m2In="'ST000000000000000000002AMW42H.pox-2"
m2Out="'ST000000000000000000002AMW42H.pox-2"

printf "Working Directory: `pwd`\n"
printf "Copying and replacing: $infile to $outfile\n"

#cp $infile/* $outfile/

sed 's/'$m1In'/'$m1Out'/g;s/'$m2In'/'$m2Out'/g;' $infile/sbtc-stacking-pool.clar > $outfile/sbtc-stacking-pool.clar

#infile=contracts/extensions/ccd007-city-stacking.clar
#outfile=tests/contracts/extensions/ccd007-city-stacking.clar

printf "Copying and replacing: $infile to $outfile\n"

#sed 's/'$m2In'/'$m2Out'/g;s/'$m3In'/'$m3Out'/g;' $infile > $outfile

printf "Finished!"

exit 0;
