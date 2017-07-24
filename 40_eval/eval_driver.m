#! /usr/bin/octave-cli -q

# Copyright (c) 2015 Alberto Otero de la Roza <aoterodelaroza@gmail.com>
#
# refdata is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Choose the energy reader and name generator
#source("reader_g09-simple.m");
# source("reader_postg-simple.m");
# source("reader_d3-simple.m");
# source("reader_espresso-simple.m");
source("reader_crystal-simple.m");
# source("reader_siesta-simple.m");
# source("reader_dftb+-simple.m");
# source("reader_sqm-simple.m");
# source("reader_orca-simple.m");
# source("reader_postg_psi4-simple.m");
 
data = {...
         ## "/home/alberto/calc/xdm_opt/15_x23_zerop/b86bpbe-xdm/",...
         ## "/home/alberto/calc/xdm_opt/15_x23_zerop/crystal-hfd2-minis-bsip7/",...
         ## "/home/alberto/calc/xdm_opt/15_x23_zerop/crystal-hfd2-minis-bsip4/",...
         ## "/home/alberto/calc/xdm_opt/45_crystalrun/hf-minis",...
         "/home/alberto/calc/xdm_opt/45_crystalrun/hfd-27",...
         ## "/home/alberto/calc/bsip2/10_transfertest/pbe0_aqz",...
      };
din = {...
        ## "../10_din/bleh.din",...
        ## "../10_din/c21.din",...
        ## "../10_din/c21_revised.din",...
        ## "../10_din/x23.din",...
        ## "../10_din/c21_prim.din",...
        ## "../10_din/c21_revised_prim.din",...
        ## "../10_din/x23_prim.din",...
        ## "../10_din/bleh.din",...
        ## "../10_din/c21_prim2.din",...
        ## "../10_din/c21_revised_prim2.din",...
        "../10_din/x23_prim2.din",...
        ## "../10_din/bleh.din",...
        ## "../10_din/water.din",...
        ## "../10_din/bleh.din",...
      };
# din = {...
#         "../10_din/water-hexamer.din",...
#         "../10_din/water-prism.din",...
#       };
# data = {...
#          "/home/alberto/temp2",...
#          "/home/alberto/temp2",...
#          "/home/alberto/temp2",...
#       };
## data = {...
##          "/home/alberto/calc/xdm_opt/45_crystalrun/test1",...
##       };
## din = {...
##         "../10_din/test1.din",...
##       };


#### Now DO stuff ####
warning("off");
format long;

## some checks
if (length(din) != length(data))
  error("Inconsistent data and din lengths")
endif
ndin = length(din);

for i = 1:ndin
  ## the din file exists?
  if (!exist(din{i},"file"))
    error(sprintf("din file does not exist: %s",din{i}))
  endif

  ## Process the outputs
  [n rxn] = load_din(din{i});
  [mad,md,rms,mapd,mpd,rmsp,maxad,maxadline,maxapd,maxapdline,elist,lines] = process_din(n,rxn,data{i},0);

  #### Simple output, whole list
  printf("## din file: %s\n",din{i});
  printf("## data file: %s\n",data{i});
  printf("## All results in kcal/mol.\n",din{i});
  printf("| name | Ref. | Calc. | \n");
  for j = 1:n
    yref = rxn{j}{end};
    printf("| %25s | %10.3f | %10.3f |\n",rxn{j}{2},yref,elist(j));
  endfor
  printf("| MAE  | -- | %.3f |\n",mad(1));
  printf("| ME   | -- | %.3f |\n",md(1));
  printf("| MAPE | -- | %.3f |\n",mapd(1));
  printf("| MPE  | -- | %.3f |\n",mpd(1));
  printf("| RMS  | -- | %.3f |\n",rms(1));
  printf("| RMSP | -- | %.3f |\n",rmsp(1));

  ## Simple output, only name of the set and MAE
  ## printf("| %s | %s | %.3f |\n",data{i},din{i},mad(1));

endfor
