-- Notices:
--
-- Copyright 2020 United States Government as represented by the Administrator of the National Aeronautics and Space Administration. All Rights Reserved.

-- Disclaimers
-- No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS, ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS, RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE, IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."

-- Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM, RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.  RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE, UNILATERAL TERMINATION OF THIS AGREEMENT.


module NumericalError where

import AbsPVSLang
import AbsSpecLang
import AbstractDomain
import AbstractSemantics
import Kodiak.Runnable
import Kodiak.Runner
import Common.DecisionPath
import Common.TypesUtils

roError :: [VarBind] -> Interpretation -> [(VarName,ACebS)] -> FAExpr -> IO Double
roError varBinds interp env ae =  maximumUpperBound <$> run kodiakInput ()
    where
        kodiakInput = KI { kiName = "error",
                           kiExpression = simplAExpr $ initAExpr $ eExpr acebAExpr,
                           kiBindings = varBinds,
                           kiMaxDepth = 7,
                           kiPrecision = 14
                           }
        acebAExpr = initErrAceb $ mergeACebFold $ stmSem ae interp (Env env) SemConf{improveError = False, assumeTestStability = False, mergeUnstables = True } (LDP []) []

computeNumRoundOffError :: [VarBind] -> EExpr -> IO Double
computeNumRoundOffError varBinds ee =  maximumUpperBound <$> run kodiakInput ()
    where
        kodiakInput = KI { kiName = "error",
                           kiExpression = simplAExpr $ initAExpr ee,
                           kiBindings = varBinds,
                           kiMaxDepth = 7,
                           kiPrecision = 14
                           }
