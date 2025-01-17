/* The following code was generated by JFlex 1.4.3 on 10/6/09 6:59 PM */

/*
    Copyright (C) 2009 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package org.jmodelica.generated.scanners;

import java.io.Reader;
import java.io.StringReader;

import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.rules.IToken;
import org.eclipse.jface.text.rules.Token;

import org.jmodelica.ide.scanners.HilightScanner;


/**
 * This class is a scanner generated by 
 * <a href="http://www.jflex.de/">JFlex</a> 1.4.3
 * on 10/6/09 6:59 PM from the specification file
 * <tt>/home/philip/workspace/JModelicaIDE/flex/Modelica22Annotation.flex</tt>
 */
public final class Modelica22AnnotationScanner extends HilightScanner {

  /** This character denotes the end of file */
  private static final int YYEOF = -1;

  /** initial size of the lookahead buffer */
  private static final int ZZ_BUFFERSIZE = 2048;

  /** lexical states */
  private static final int COMMENT_ONE_LINE = 4;
  private static final int YYINITIAL = 0;
  private static final int COMMENTSTATE = 2;

  /**
   * ZZ_LEXSTATE[l] is the state in the DFA for the lexical state l
   * ZZ_LEXSTATE[l+1] is the state in the DFA for the lexical state l
   *                  at the beginning of a line
   * l is of the form l = 2*k, k a non negative integer
   */
  private static final int ZZ_LEXSTATE[] = { 
     0,  0,  1,  1,  2, 2
  };

  /** 
   * Translates characters to character classes
   */
  private static final String ZZ_CMAP_PACKED = 
    "\11\0\1\24\1\23\1\0\1\24\1\22\22\0\1\24\1\0\1\5"+
    "\4\0\1\4\1\40\1\41\1\42\1\21\1\41\1\21\1\1\1\43"+
    "\12\16\1\41\1\41\1\41\1\44\1\41\1\6\1\0\4\2\1\20"+
    "\25\2\1\41\1\3\1\41\1\41\1\2\1\0\1\7\1\10\1\25"+
    "\1\32\1\17\1\11\1\2\1\26\1\27\2\2\1\30\1\37\1\12"+
    "\1\33\1\31\1\2\1\13\1\35\1\14\1\34\1\15\1\36\3\2"+
    "\1\41\1\0\1\41\uff82\0";

  /** 
   * Translates characters to character classes
   */
  private static final char [] ZZ_CMAP = zzUnpackCMap(ZZ_CMAP_PACKED);

  /** 
   * Translates DFA states to action switch labels.
   */
  private static final int [] ZZ_ACTION = zzUnpackAction();

  private static final String ZZ_ACTION_PACKED_0 =
    "\1\1\1\0\1\2\1\1\1\3\12\1\1\3\1\1"+
    "\1\4\5\1\1\5\3\4\1\1\1\0\1\6\1\7"+
    "\4\0\1\10\12\1\1\0\3\1\1\11\4\1\1\5"+
    "\1\12\10\1\1\0\11\1\1\11\23\1";

  private static int [] zzUnpackAction() {
    int [] result = new int[95];
    int offset = 0;
    offset = zzUnpackAction(ZZ_ACTION_PACKED_0, offset, result);
    return result;
  }

  private static int zzUnpackAction(String packed, int offset, int [] result) {
    int i = 0;       /* index in packed string  */
    int j = offset;  /* index in unpacked array */
    int l = packed.length();
    while (i < l) {
      int count = packed.charAt(i++);
      int value = packed.charAt(i++);
      do result[j++] = value; while (--count > 0);
    }
    return j;
  }


  /** 
   * Translates a state to a row index in the transition table
   */
  private static final int [] ZZ_ROWMAP = zzUnpackRowMap();

  private static final String ZZ_ROWMAP_PACKED_0 =
    "\0\0\0\45\0\112\0\157\0\224\0\271\0\336\0\u0103"+
    "\0\u0128\0\u014d\0\u0172\0\u0197\0\u01bc\0\u01e1\0\u0206\0\u022b"+
    "\0\u0250\0\u0275\0\u029a\0\u02bf\0\u02e4\0\u0309\0\u032e\0\u0353"+
    "\0\u0378\0\u039d\0\157\0\u03c2\0\u03e7\0\157\0\157\0\u040c"+
    "\0\u0431\0\u0103\0\u0456\0\157\0\u047b\0\u04a0\0\u04c5\0\u04ea"+
    "\0\u050f\0\u0534\0\u0559\0\u057e\0\u05a3\0\u05c8\0\u05ed\0\u0612"+
    "\0\u0637\0\u065c\0\271\0\u0681\0\u06a6\0\u06cb\0\u06f0\0\157"+
    "\0\157\0\u03e7\0\u0715\0\u073a\0\u075f\0\u0784\0\u07a9\0\u07ce"+
    "\0\u07f3\0\u03c2\0\u0818\0\u083d\0\u0862\0\u0887\0\u08ac\0\u08d1"+
    "\0\u08f6\0\u091b\0\u0940\0\u0965\0\u098a\0\u09af\0\u09d4\0\u09f9"+
    "\0\u0a1e\0\u0a43\0\u0a68\0\u0a8d\0\u0ab2\0\u0ad7\0\u0afc\0\u0b21"+
    "\0\u0b46\0\u0b6b\0\u0b90\0\u0bb5\0\u0bda\0\u0bff\0\u0c24";

  private static int [] zzUnpackRowMap() {
    int [] result = new int[95];
    int offset = 0;
    offset = zzUnpackRowMap(ZZ_ROWMAP_PACKED_0, offset, result);
    return result;
  }

  private static int zzUnpackRowMap(String packed, int offset, int [] result) {
    int i = 0;  /* index in packed string  */
    int j = offset;  /* index in unpacked array */
    int l = packed.length();
    while (i < l) {
      int high = packed.charAt(i++) << 16;
      result[j++] = high | packed.charAt(i++);
    }
    return j;
  }

  /** 
   * The transition table of the DFA
   */
  private static final int ZZ_TRANS [] = {
    3, 4, 5, 3, 6, 7, 3, 8, 5, 9, 
    10, 11, 12, 5, 13, 14, 5, 15, 16, 16, 
    17, 18, 5, 19, 5, 20, 21, 22, 5, 5, 
    5, 5, 15, 15, 15, 15, 15, 23, 23, 23, 
    24, 23, 23, 23, 23, 23, 23, 23, 23, 23, 
    23, 23, 23, 23, 23, 16, 16, 23, 23, 23, 
    23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 
    23, 25, 26, 23, 2, 2, 2, 2, 2, 2, 
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 
    2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, 15, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 27, -1, -1, 15, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    15, 15, 15, 15, 15, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, -1, 28, 28, 28, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, 31, 31, 31, 32, -1, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, 31, 31, 33, 
    33, 33, 34, 33, 35, 33, 33, 33, 33, 33, 
    33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 
    33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 
    33, 33, 33, 33, 33, 33, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 36, 5, 5, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    37, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    -1, 28, 28, 28, 5, 5, 38, 39, 5, 5, 
    40, 5, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 5, 5, 5, 41, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 5, 5, 
    5, 5, 42, 5, -1, 28, 28, 28, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 43, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 44, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 45, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 13, 46, 46, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, 5, 
    5, -1, -1, -1, -1, 47, 5, 5, 36, 5, 
    5, 5, 5, 5, 5, -1, 28, 28, 28, 5, 
    5, 5, 48, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 15, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, 15, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 15, 15, 15, 
    15, 15, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    16, 16, 16, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, 17, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 49, 5, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 50, 51, 5, 5, 5, 5, 5, 5, 
    -1, 28, 28, 28, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 52, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 5, 5, 
    53, 5, 5, 5, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 50, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 5, 5, 5, 5, 
    5, 5, 54, 5, 5, 5, 29, -1, -1, -1, 
    30, 23, 23, 23, -1, 23, 23, 23, 23, 23, 
    23, 23, 23, 23, 23, 23, 23, 23, 23, -1, 
    -1, 23, 23, 23, 23, 23, 23, 23, 23, 23, 
    23, 23, 23, 23, 23, -1, -1, 23, 55, 55, 
    55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 
    55, 55, 55, 55, 55, 55, 55, -1, 55, 55, 
    55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 
    55, 55, 55, 55, 55, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    56, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 27, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 28, 28, 28, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 29, -1, -1, -1, 30, 31, 31, 31, 32, 
    57, 31, 31, 31, 31, 31, 31, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 
    31, 31, 31, -1, -1, -1, 31, 31, 31, 31, 
    31, 31, 31, 31, 31, 31, 31, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 33, 33, 33, 33, 33, 33, 33, 
    33, 33, 33, 33, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 5, 5, 
    5, 5, 5, 50, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 5, 5, 58, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 5, 5, 
    5, 59, 5, 5, 5, 5, 5, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, -1, 28, 28, 28, 5, 
    5, 5, 5, 5, 5, 60, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 5, 50, 5, 5, 5, 
    5, 5, -1, 28, 28, 28, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, -1, 5, 5, -1, -1, -1, -1, 5, 
    5, 5, 5, 5, 50, 5, 5, 5, 5, -1, 
    28, 28, 28, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 29, -1, -1, -1, 30, -1, 
    5, 5, -1, -1, -1, -1, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, -1, 28, 28, 28, 
    5, 5, 5, 5, 61, 62, 5, 5, 5, 5, 
    5, 29, -1, -1, -1, 30, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 63, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 5, 5, 5, 5, 5, 5, 64, 5, 
    -1, 28, 28, 28, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 45, 46, 46, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, 27, -1, -1, 65, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 66, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    67, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 68, 5, 
    5, 5, 5, 5, 5, -1, 28, 28, 28, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, -1, 28, 28, 28, 5, 5, 5, 5, 
    69, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, -1, 5, 5, -1, -1, -1, -1, 5, 
    5, 5, 5, 70, 5, 5, 5, 5, 5, -1, 
    28, 28, 28, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 29, -1, -1, -1, 30, -1, 
    5, 5, -1, -1, -1, -1, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, -1, 28, 28, 28, 
    5, 5, 5, 5, 5, 5, 5, 5, 71, 5, 
    5, 29, -1, -1, -1, 30, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 5, 51, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    -1, 28, 28, 28, 5, 5, 5, 5, 5, 5, 
    5, 5, 63, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 72, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 50, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 5, 5, 73, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 5, 5, 
    5, 5, 5, 5, 5, 5, 74, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 5, 5, 
    5, 5, 5, 50, 5, -1, 28, 28, 28, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 50, 5, 5, 5, 5, 
    5, 5, -1, 28, 28, 28, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, -1, 5, 5, -1, -1, -1, -1, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, -1, 
    28, 28, 28, 5, 50, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 29, -1, -1, -1, 30, -1, 
    5, 5, -1, -1, -1, -1, 5, 5, 5, 5, 
    5, 5, 5, 5, 75, 5, -1, 28, 28, 28, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 29, -1, -1, -1, 30, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 5, 76, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    -1, 28, 28, 28, 5, 5, 5, 5, 5, 5, 
    5, 41, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 77, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 78, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 5, 5, 50, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 79, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, -1, 28, 28, 28, 80, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, -1, 28, 28, 28, 5, 5, 81, 5, 
    5, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, -1, 5, 5, -1, -1, -1, -1, 5, 
    5, 5, 5, 5, 82, 5, 5, 5, 5, -1, 
    28, 28, 28, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 29, -1, -1, -1, 30, -1, 
    5, 5, -1, -1, -1, -1, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, -1, 28, 28, 28, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    83, 29, -1, -1, -1, 30, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 84, 5, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    -1, 28, 28, 28, 85, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 86, 5, 5, 5, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 50, 5, 5, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 87, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, -1, 28, 28, 28, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 5, 5, 
    5, 5, 5, 5, 5, 5, 88, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 5, 5, 
    5, 5, 5, 89, 5, -1, 28, 28, 28, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, -1, 5, 5, -1, -1, 
    -1, -1, 5, 5, 5, 5, 5, 5, 5, 5, 
    90, 5, -1, 28, 28, 28, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 29, -1, -1, 
    -1, 30, -1, 5, 5, -1, -1, -1, -1, 91, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, -1, 
    28, 28, 28, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 29, -1, -1, -1, 30, -1, 
    5, 5, -1, -1, -1, -1, 5, 5, 5, 41, 
    5, 5, 5, 5, 5, 5, -1, 28, 28, 28, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 29, -1, -1, -1, 30, -1, 5, 5, -1, 
    -1, -1, -1, 5, 5, 5, 5, 5, 92, 5, 
    5, 5, 5, -1, 28, 28, 28, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 29, -1, 
    -1, -1, 30, -1, 5, 5, -1, -1, -1, -1, 
    5, 5, 5, 5, 5, 63, 5, 5, 5, 5, 
    -1, 28, 28, 28, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 29, -1, -1, -1, 30, 
    -1, 5, 5, -1, -1, -1, -1, 93, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, -1, 28, 28, 
    28, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 29, -1, -1, -1, 30, -1, 5, 5, 
    -1, -1, -1, -1, 5, 5, 5, 5, 63, 5, 
    5, 5, 5, 5, -1, 28, 28, 28, 5, 5, 
    5, 5, 5, 5, 5, 5, 5, 5, 5, 29, 
    -1, -1, -1, 30, -1, 5, 5, -1, -1, -1, 
    -1, 5, 5, 5, 5, 5, 5, 5, 5, 40, 
    5, -1, 28, 28, 28, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 5, 29, -1, -1, -1, 
    30, -1, 5, 5, -1, -1, -1, -1, 5, 94, 
    5, 5, 5, 5, 5, 5, 5, 5, -1, 28, 
    28, 28, 5, 5, 5, 5, 5, 5, 5, 5, 
    5, 5, 5, 29, -1, -1, -1, 30, -1, 5, 
    5, -1, -1, -1, -1, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, -1, 28, 28, 28, 5, 
    5, 5, 63, 5, 5, 5, 5, 5, 5, 5, 
    29, -1, -1, -1, 30, 
  };

  /* error codes */
  private static final int ZZ_UNKNOWN_ERROR = 0;
  private static final int ZZ_NO_MATCH = 1;
  private static final int ZZ_PUSHBACK_2BIG = 2;

  /* error messages for the codes above */
  private static final String ZZ_ERROR_MSG[] = {
    "Unkown internal scanner error",
    "Error: could not match input",
    "Error: pushback value was too large"
  };

  /**
   * ZZ_ATTRIBUTE[aState] contains the attributes of state <code>aState</code>
   */
  private static final int [] ZZ_ATTRIBUTE = zzUnpackAttribute();

  private static final String ZZ_ATTRIBUTE_PACKED_0 =
    "\1\1\1\0\1\1\1\11\26\1\1\11\1\1\1\0"+
    "\2\11\4\0\1\11\12\1\1\0\10\1\2\11\10\1"+
    "\1\0\35\1";

  private static int [] zzUnpackAttribute() {
    int [] result = new int[95];
    int offset = 0;
    offset = zzUnpackAttribute(ZZ_ATTRIBUTE_PACKED_0, offset, result);
    return result;
  }

  private static int zzUnpackAttribute(String packed, int offset, int [] result) {
    int i = 0;       /* index in packed string  */
    int j = offset;  /* index in unpacked array */
    int l = packed.length();
    while (i < l) {
      int count = packed.charAt(i++);
      int value = packed.charAt(i++);
      do result[j++] = value; while (--count > 0);
    }
    return j;
  }

  /** the input device */
  private java.io.Reader zzReader;

  /** the current state of the DFA */
  private int zzState;

  /** the current lexical state */
  private int zzLexicalState = YYINITIAL;

  /** this buffer contains the current text to be matched and is
      the source of the yytext() string */
  private char zzBuffer[] = new char[ZZ_BUFFERSIZE];

  /** the textposition at the last accepting state */
  private int zzMarkedPos;

  /** the current text position in the buffer */
  private int zzCurrentPos;

  /** startRead marks the beginning of the yytext() string in the buffer */
  private int zzStartRead;

  /** endRead marks the last character in the buffer, that has been read
      from input */
  private int zzEndRead;

  /** number of newlines encountered up to the start of the matched text */
  private int yyline;

  /** the number of characters up to the start of the matched text */
  private int yychar;

  /**
   * the number of characters from the last newline up to the start of the 
   * matched text
   */
  private int yycolumn;

  /** 
   * zzAtBOL == true <=> the scanner is currently at the beginning of a line
   */
  private boolean zzAtBOL = true;

  /** zzAtEOF == true <=> the scanner is at the EOF */
  private boolean zzAtEOF;

  /** denotes if the user-EOF-code has already been executed */
  private boolean zzEOFDone;

  /* user code: */
    private int start;
    private IToken last_token;
    
    public Modelica22AnnotationScanner() {
        this(new StringReader(""));
    }
    
    public IToken nextToken() {
        try {
            return nextTokenInternal();
        } catch (java.io.IOException e) {
            return Token.EOF;
        }
    }

    public int getTokenLength() {
    	return yylength();
    }

    public int getTokenOffset() {
    	return start + yychar;
    }

    public void setRange(IDocument document, int offset, int length) {
        start = offset;
        last_token = ANNOTATION_NORMAL;
    	reset(document, offset, length);	
    }
    
    protected void reset(Reader r) {
        yyreset(r);
    }
    
    protected IToken rtn(IToken token) {
    	last_token = token;
    	return token;
    }


  /**
   * Creates a new scanner
   * There is also a java.io.InputStream version of this constructor.
   *
   * @param   in  the java.io.Reader to read input from.
   */
  public Modelica22AnnotationScanner(java.io.Reader in) {
    this.zzReader = in;
  }

  /**
   * Creates a new scanner.
   * There is also java.io.Reader version of this constructor.
   *
   * @param   in  the java.io.Inputstream to read input from.
   */
  public Modelica22AnnotationScanner(java.io.InputStream in) {
    this(new java.io.InputStreamReader(in));
  }

  /** 
   * Unpacks the compressed character translation table.
   *
   * @param packed   the packed character translation table
   * @return         the unpacked character translation table
   */
  private static char [] zzUnpackCMap(String packed) {
    char [] map = new char[0x10000];
    int i = 0;  /* index in packed string  */
    int j = 0;  /* index in unpacked array */
    while (i < 128) {
      int  count = packed.charAt(i++);
      char value = packed.charAt(i++);
      do map[j++] = value; while (--count > 0);
    }
    return map;
  }


  /**
   * Refills the input buffer.
   *
   * @return      <code>false</code>, iff there was new input.
   * 
   * @exception   java.io.IOException  if any I/O-Error occurs
   */
  private boolean zzRefill() throws java.io.IOException {

    /* first: make room (if you can) */
    if (zzStartRead > 0) {
      System.arraycopy(zzBuffer, zzStartRead,
                       zzBuffer, 0,
                       zzEndRead-zzStartRead);

      /* translate stored positions */
      zzEndRead-= zzStartRead;
      zzCurrentPos-= zzStartRead;
      zzMarkedPos-= zzStartRead;
      zzStartRead = 0;
    }

    /* is the buffer big enough? */
    if (zzCurrentPos >= zzBuffer.length) {
      /* if not: blow it up */
      char newBuffer[] = new char[zzCurrentPos*2];
      System.arraycopy(zzBuffer, 0, newBuffer, 0, zzBuffer.length);
      zzBuffer = newBuffer;
    }

    /* finally: fill the buffer with new input */
    int numRead = zzReader.read(zzBuffer, zzEndRead,
                                            zzBuffer.length-zzEndRead);

    if (numRead > 0) {
      zzEndRead+= numRead;
      return false;
    }
    // unlikely but not impossible: read 0 characters, but not at end of stream    
    if (numRead == 0) {
      int c = zzReader.read();
      if (c == -1) {
        return true;
      } else {
        zzBuffer[zzEndRead++] = (char) c;
        return false;
      }     
    }

	// numRead < 0
    return true;
  }

    
  /**
   * Closes the input stream.
   */
  private final void yyclose() throws java.io.IOException {
    zzAtEOF = true;            /* indicate end of file */
    zzEndRead = zzStartRead;  /* invalidate buffer    */

    if (zzReader != null)
      zzReader.close();
  }


  /**
   * Resets the scanner to read from a new input stream.
   * Does not close the old reader.
   *
   * All internal variables are reset, the old input stream 
   * <b>cannot</b> be reused (internal buffer is discarded and lost).
   * Lexical state is set to <tt>ZZ_INITIAL</tt>.
   *
   * @param reader   the new input stream 
   */
  private final void yyreset(java.io.Reader reader) {
    zzReader = reader;
    zzAtBOL  = true;
    zzAtEOF  = false;
    zzEOFDone = false;
    zzEndRead = zzStartRead = 0;
    zzCurrentPos = zzMarkedPos = 0;
    yyline = yychar = yycolumn = 0;
    zzLexicalState = YYINITIAL;
  }


  /**
   * Returns the current lexical state.
   */
  private final int yystate() {
    return zzLexicalState;
  }


  /**
   * Enters a new lexical state
   *
   * @param newState the new lexical state
   */
  private final void yybegin(int newState) {
    zzLexicalState = newState;
  }


  /**
   * Returns the text matched by the current regular expression.
   */
  private final String yytext() {
    return new String( zzBuffer, zzStartRead, zzMarkedPos-zzStartRead );
  }


  /**
   * Returns the character at position <tt>pos</tt> from the 
   * matched text. 
   * 
   * It is equivalent to yytext().charAt(pos), but faster
   *
   * @param pos the position of the character to fetch. 
   *            A value from 0 to yylength()-1.
   *
   * @return the character at position pos
   */
  private final char yycharat(int pos) {
    return zzBuffer[zzStartRead+pos];
  }


  /**
   * Returns the length of the matched text region.
   */
  private final int yylength() {
    return zzMarkedPos-zzStartRead;
  }


  /**
   * Reports an error that occured while scanning.
   *
   * In a wellformed scanner (no or only correct usage of 
   * yypushback(int) and a match-all fallback rule) this method 
   * will only be called with things that "Can't Possibly Happen".
   * If this method is called, something is seriously wrong
   * (e.g. a JFlex bug producing a faulty scanner etc.).
   *
   * Usual syntax/scanner level error handling should be done
   * in error fallback rules.
   *
   * @param   errorCode  the code of the errormessage to display
   */
  private void zzScanError(int errorCode) {
    String message;
    try {
      message = ZZ_ERROR_MSG[errorCode];
    }
    catch (ArrayIndexOutOfBoundsException e) {
      message = ZZ_ERROR_MSG[ZZ_UNKNOWN_ERROR];
    }

    throw new Error(message);
  } 


  /**
   * Pushes the specified amount of characters back into the input stream.
   *
   * They will be read again by then next call of the scanning method
   *
   * @param number  the number of characters to be read again.
   *                This number must not be greater than yylength()!
   */
  private void yypushback(int number)  {
    if ( number > yylength() )
      zzScanError(ZZ_PUSHBACK_2BIG);

    zzMarkedPos -= number;
  }


  /**
   * Resumes scanning until the next regular expression is matched,
   * the end of input is encountered or an I/O-Error occurs.
   *
   * @return      the next token
   * @exception   java.io.IOException  if any I/O-Error occurs
   */
  private IToken nextTokenInternal() throws java.io.IOException {
    int zzInput;
    int zzAction;

    // cached fields:
    int zzCurrentPosL;
    int zzMarkedPosL;
    int zzEndReadL = zzEndRead;
    char [] zzBufferL = zzBuffer;
    char [] zzCMapL = ZZ_CMAP;

    int [] zzTransL = ZZ_TRANS;
    int [] zzRowMapL = ZZ_ROWMAP;
    int [] zzAttrL = ZZ_ATTRIBUTE;

    while (true) {
      zzMarkedPosL = zzMarkedPos;

      yychar+= zzMarkedPosL-zzStartRead;

      zzAction = -1;

      zzCurrentPosL = zzCurrentPos = zzStartRead = zzMarkedPosL;
  
      zzState = ZZ_LEXSTATE[zzLexicalState];


      zzForAction: {
        while (true) {
    
          if (zzCurrentPosL < zzEndReadL)
            zzInput = zzBufferL[zzCurrentPosL++];
          else if (zzAtEOF) {
            zzInput = YYEOF;
            break zzForAction;
          }
          else {
            // store back cached positions
            zzCurrentPos  = zzCurrentPosL;
            zzMarkedPos   = zzMarkedPosL;
            boolean eof = zzRefill();
            // get translated positions and possibly new buffer
            zzCurrentPosL  = zzCurrentPos;
            zzMarkedPosL   = zzMarkedPos;
            zzBufferL      = zzBuffer;
            zzEndReadL     = zzEndRead;
            if (eof) {
              zzInput = YYEOF;
              break zzForAction;
            }
            else {
              zzInput = zzBufferL[zzCurrentPosL++];
            }
          }
          int zzNext = zzTransL[ zzRowMapL[zzState] + zzCMapL[zzInput] ];
          if (zzNext == -1) break zzForAction;
          zzState = zzNext;

          int zzAttributes = zzAttrL[zzState];
          if ( (zzAttributes & 1) == 1 ) {
            zzAction = zzState;
            zzMarkedPosL = zzCurrentPosL;
            if ( (zzAttributes & 8) == 8 ) break zzForAction;
          }

        }
      }

      // store back cached position
      zzMarkedPos = zzMarkedPosL;

      switch (zzAction < 0 ? zzAction : ZZ_ACTION[zzAction]) {
        case 3: 
          { return rtn(ANNOTATION_OPERATOR);
          }
        case 11: break;
        case 1: 
          { return rtn(ANNOTATION_NORMAL);
          }
        case 12: break;
        case 7: 
          // lookahead expression with fixed lookahead length
          yypushback(1);
          { return rtn(ANNOTATION_LHS);
          }
        case 13: break;
        case 4: 
          { return rtn(last_token);
          }
        case 14: break;
        case 2: 
          { yybegin(YYINITIAL); return rtn(COMMENT);
          }
        case 15: break;
        case 10: 
          { yybegin(YYINITIAL); return rtn(COMMENT_BOUNDARY);
          }
        case 16: break;
        case 5: 
          { return rtn(COMMENT);
          }
        case 17: break;
        case 6: 
          // lookahead expression with fixed lookahead length
          yypushback(1);
          { return rtn(ANNOTATION_RHS);
          }
        case 18: break;
        case 8: 
          { return rtn(ANNOTATION_STRING);
          }
        case 19: break;
        case 9: 
          { return rtn(ANNOTATION_KEYWORD);
          }
        case 20: break;
        default: 
          if (zzInput == YYEOF && zzStartRead == zzCurrentPos) {
            zzAtEOF = true;
              {
                return rtn(Token.EOF);
              }
          } 
          else {
            zzScanError(ZZ_NO_MATCH);
          }
      }
    }
  }


}
