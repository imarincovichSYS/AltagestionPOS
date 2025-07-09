// PopupNavigator -  web-site navigation pop-up menu Java applet.
// Copyright © 1999-2000 Branko Dimitrijevic
// bepp@bepp.8m.com
// http://bepp.8m.com

package PopupNavigator;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.util.StringTokenizer;
import java.net.URL;
import java.net.MalformedURLException;



// TODO: Support for settig predefined cursor or loading
// a cursor from URL.

// TODO: Support for foregraund color, background color,
// icons, foreground and background image.

// TODO: Merge PopupNavigatorMenu and PopupNavigatorMenuItem?

// TODO: Support for system colors.

// TODO: Support for configuration file.
//   1) For menu tree only.
//   2) For everything except menu tree.
//   3) For both 1) and 2).

// TODO: Test when there is too mutch sub-parameters.



class PopupNavigatorMenu extends Menu {

  // We don't use Font class because we need to know what values are
  // default (null) - after temporary change of font.
  public String fontName = null;
  public Integer fontStyle = null, fontSize = null;

  public PopupNavigatorMenu(String label) {
    super(label);
  }

}



// We need special class to store URLs.
class PopupNavigatorMenuItem extends MenuItem {

  public URL url = null;
  // Stores URLs that are in the different domain (to avoid premature DNS lookups).
  public String url_string = null;
  public String frame = null;

  // We don't use Font class becouse we need to know what values are
  // default (null) - after temporary change of font.
  public String fontName = null;
  public Integer fontStyle = null, fontSize = null;

  public PopupNavigatorMenuItem(String label) {
    super(label);
  }

} // PopupNavigatorMenuItem



public class PopupNavigatorApplet extends Applet {

  // True if mouse is inside applet.
  private boolean mouseIn = false;
  private boolean mouseDown = false;

  // Maximum number of semicolon-delimited tokens (sub-parameters)
  // within single applet parameter value.
  private static final short MaxSubParameters = 9;

  private static final short MaxMenuDepth = 10;

  private char delimiterChar = ';';
  private char escapeChar = '\\';
  private String URLBase = "CODEBASE";

  private String defaultFontName = "Dialog";
  private String defaultFontStyle = "PLAIN";
  private String defaultFontSize = "12";
  private String defaultForegroundColor = "BLACK";
  private String defaultBackgroundColor = "LIGHTGRAY";
  // We don't use "_self" as default because of posibility to improve
  // compatibility with non-frames browsers (HotJava?) by not caling
  // frame-enabled showDocumetn(). I don't know if this is effective.
  private String defaultFrame = null;

  // Selection method constants.
  private static final String smRecursive = "RECURSIVE";
  private static final String smItem = "ITEM";
  private static final String smNone = "NONE";

  private String selectionMode = smRecursive;
  private String selectionFontName = null;
  private String selectionFontStyle = "BOLD";
  private String selectionFontSize = null;

  private String menuActivation = "CLICK";
  private String statusText = null;

  private String menuPosition = "BOTTOM";
  private String missingURL = "ERROR";

  // Used in paint().
  private String labelText = null;
  private Font labelFont = null;
  private Color labelForeground = null;
  private Color labelBackground = null;

  private String mouseoverLabelText = null;
  private Font mouseoverLabelFont = null;
  private Color mouseoverLabelForeground = null;
  private Color mouseoverLabelBackground = null;

  private String clickLabelText = null;
  private Font clickLabelFont = null;
  private Color clickLabelForeground = null;
  private Color clickLabelBackground = null;

  // Button style constants.
  private static final String bsFlat = "FLAT";
  private static final String bsSemiflat = "SEMIFLAT";
  private static final String bsNormal = "NORMAL";

  // Button hover constants.
  private static final String bhHover = "HOVER";
  private static final String bhNohover = "NOHOVER";

  // ButtonStyle = style;hover.
  private String buttonStyle = bsNormal;
  private String buttonHover = bhHover; // Mouseover effect.

  private Image buttonImage = null;
  private Image mouseoverButtonImage = null;
  private Image clickButtonImage = null;

  private static final String bipAbsolute = "ABSOLUTE";
  private static final String bipCenter = "CENTER";
  private static final String bipLeft = "LEFT";
  private static final String bipRight = "RIGHT";
  private static final String bipTop = "TOP";
  private static final String bipBottom = "BOTTOM";

  private String buttonImagePosition = "ABSOLUTE";
  private String buttonImagePositionX = "0";
  private String buttonImagePositionY = "0";
  private String mouseoverButtonImagePosition = null;
  private String mouseoverButtonImagePositionX = null;
  private String mouseoverButtonImagePositionY = null;
  private String clickButtonImagePosition = null;
  private String clickButtonImagePositionX = null;
  private String clickButtonImagePositionY = null;

  // Last selected menu item. Used to improve compatibility
  // with frames. In IE5 this doesn't work.
  PopupNavigatorMenuItem oldSelection = null;

  // Used in loadMenu(). Not static because of multi-use of the same applet
  // in one web page.
  short[] paramCoord = new short[MaxMenuDepth];

  boolean isStandalone = false;
  GridLayout gridLayout1 = new GridLayout();
  PopupMenu popupMenu = new PopupMenu();

  // Get a parameter value. If parameter is not found, def is returned.
  public String getParameter(String key, String def) {
    String tmp;
    tmp = isStandalone ? System.getProperty(key, def) : getParameter(key);
    if (tmp == null)
      tmp = def;
    if (tmp != null)
      tmp = tmp.trim();
    return tmp;
  }

  private Image getImageFromParam(String paramName, Image def) {
    String paramValue;
    paramValue = getParameter(paramName,null);
    if (paramValue == null)
      return def;
    else if (paramValue.length() == 0)
      return null;
    else
      return getImage(encodeURL(paramValue));
  }

  // Returns true if url_string references current domain.
  // Important to avoid unneccessary DNS lookups.
  private boolean isCurrentDomain(final String url_string) {

    // url_string can not be local if it contains "://" or begins with "mailto:".

    String Url = url_string.trim();

    // Strts with "mailto:"?
    if (Url.startsWith("mailto:"))
      return false;


    //for (int i=0; i<Url.length(); ++i) {
    //  if (
    //    Url.charAt(i) == ':'
    //    && i+1 < Url.length()
    //    && Url.charAt(i+1) == '/'
    //    && i+2 < Url.length()
    //    && Url.charAt(i+2) == '/'
    //  ) {
    //} // for search for "://"

    //for (int i = 0; i+2 < Url.length(); ++i) {
    //  if (
    //    Url.charAt(i) == ':'
    //    && Url.charAt(i+1) == '/'
    //    && Url.charAt(i+2) == '/'
    //  ) {
    //} // for search for "://"

    // Contains "://"?
    int i = Url.indexOf("://");
    if (i >= 0) {
      // url_string is not local if its beginning is different then
      // local protocol + local host.
      URL base = getDocumentBase();
      String Protocol = base.getProtocol();
      if (Protocol.equalsIgnoreCase("mailto"))
        Protocol = "mailto:";
      else
        Protocol = Protocol + "://";
      String Host = base.getHost();
      return Url.toLowerCase().startsWith((Protocol + Host).toLowerCase());
    } // if found "://"

    return true;

  } // isCurrentDomain()

  // Returns URL depending on UrlStr parameter and the URLBase parameter.
  private URL encodeURL(String UrlStr) {
    URL base;
    try {
      if (URLBase.equalsIgnoreCase("CODEBASE"))
        base = this.getCodeBase();
      else if (URLBase.equalsIgnoreCase("DOCUMENT"))
        base = this.getDocumentBase();
      else
        base = new URL(URLBase);
      return new URL(base,UrlStr);
    }
    catch (MalformedURLException x) {
      return null;
    }

    /*
    catch (MalformedURLException x) {
      if (!hasErrors) {
        Tokens[0] = formatErrorLabel(
          null,"MALFORMED URL",paramKey.toString(),paramValue);
        hasErrors = true;
      }
    }
    */
  }

  // Decodes semicolon-delimited 'value' and returns array
  // of it's tokens (sub-parameters). StringTokenizer is not
  // used becouse we need support for escape character
  // (backslash). Named sub-parameters will be implemented
  // later. Skipped sub-parameters will be assigned 'Defaults'
  // members with same index. If 'Defaults' is null, then
  // nulls will be assigned to skipped tokens.

  private String[] decodeParamValue(String value, String[] Defaults) throws Exception {

    // TODO: Support for named parameters.

    String[] Tokens = new String[MaxSubParameters];
    int i,currentTokenIndex;

    if (Defaults!=null && Defaults.length>MaxSubParameters)
      throw(new Exception("PopupNavigatorApplet.decodeParamValue() Defaults out of range."));

    StringBuffer currentToken = new StringBuffer();

    for (i=0,currentTokenIndex=0; i<value.length(); ++i) {
      if (value.charAt(i) == escapeChar) {
        ++i;  // Skipping escape.
        if (i<value.length())
          currentToken.append(value.charAt(i)); // Adding character after escape.
      }
      else if (value.charAt(i) == delimiterChar) {
        if (currentToken.length() > 0) { // To leave default or null for skipped sub-parameters.
          Tokens[currentTokenIndex] = currentToken.toString();
          currentToken = new StringBuffer();
        }
        else if (Defaults!=null && currentTokenIndex<Defaults.length) {
          Tokens[currentTokenIndex] = Defaults[currentTokenIndex];
        }
        ++currentTokenIndex;
      }
      else
        currentToken.append(value.charAt(i));
    } // for (iterate through 'value')


    // Last token doesn't need to finish with ';'.
    if (currentToken.length() > 0)  // To leave default or null if last sub-parameter is skipped.
      Tokens[currentTokenIndex++] = currentToken.toString();
    else if (Defaults!=null && currentTokenIndex<Defaults.length) {
      Tokens[currentTokenIndex] = Defaults[currentTokenIndex];
      ++currentTokenIndex;
    }

    // Applying the rest of defaults.
    if (Defaults != null)
      while (currentTokenIndex < Defaults.length) {
        Tokens[currentTokenIndex] = Defaults[currentTokenIndex];
        ++currentTokenIndex;
      }

    return Tokens;

  } // decodeParamValue()



  // Converts string representation of font style to int (as defined
  // in Font class). On failure returns Font.PLAIN - because of
  // robustness.
  private int strToFontStyle(String style) {

    String stylestr = style.toUpperCase();

    //if (stylestr.equals("PLAIN"))
    //  return Font.PLAIN;
    //else
    if (stylestr.equals("BOLD"))
      return Font.BOLD;
    else if (stylestr.equals("ITALIC"))
      return Font.ITALIC;
    else if (stylestr.equals("BOLDITALIC") || stylestr.equals("ITALICBOLD"))
      return Font.BOLD + Font.ITALIC;
    else
      return Font.PLAIN;

  } // strToFontStyle



  private Color strToColor(String value) throws Exception {

    // TODO: Support for system color (CONTROL,...).

    Color result = null;

    // Named color.
    if (Character.isLetter(value.charAt(0))) {
      // We don't want to change 'value'.
      String tmp = value.trim().toUpperCase();  // trim: doesn't change this - returns new string.

      if (tmp.equals("BLACK"))
        result = Color.black;
      else if (tmp.equals("BLUE"))
        result = Color.blue;
      else if (tmp.equals("CYAN"))
        result = Color.cyan;
      else if (tmp.equals("DARKGRAY"))
        result = Color.darkGray;
      else if (tmp.equals("GRAY"))
        result = Color.gray;
      else if (tmp.equals("GREEN"))
        result = Color.green;
      else if (tmp.equals("LIGHTGRAY"))
        result = Color.lightGray;
      else if (tmp.equals("MAGENTA"))
        result = Color.magenta;
      else if (tmp.equals("ORANGE"))
        result = Color.orange;
      else if (tmp.equals("PINK"))
        result = Color.pink;
      else if (tmp.equals("RED"))
        result = Color.red;
      else if (tmp.equals("WHITE"))
        result = Color.white;
      else if (tmp.equals("YELLOW"))
        result = Color.yellow;

      // TODO: Support for system colors.

    } // if named color

    // One integer or space-delimited three-integer color.
    else {
      StringTokenizer st = new StringTokenizer(value," ",false);
      Integer r=null,g=null,b=null;

      if (st.hasMoreTokens()) {
        r = new Integer(st.nextToken());
        if (st.hasMoreTokens()) {
          g = new Integer(st.nextToken());
          if (st.hasMoreTokens())
            b = new Integer(st.nextToken());
        }
      }
      else
        throw new Exception("PopupNavigator.strToColor() Bad color formatting.");

      if (g == null)
        result = new Color(r.intValue()); // r contains whole RGB value.
      else {
        if (b == null)  // Error only b has no value.
          throw new Exception("PopupNavigator.strToColor() Bad color formatting - blue is missing.");
        else // All r, g and b have value.
          result = new Color(r.intValue(),g.intValue(),b.intValue());
      }
    } // else it's number

    return result;

  } // strToColor()

  private boolean strToBoolean(String value) {
    if (value.equalsIgnoreCase("TRUE"))
      return true;
    else
      return false;
  }



  //Construct the applet
  public PopupNavigatorApplet() {
  }



  // Returns Font constructed from begin-th Token (begin, begin+1 and
  // begin+2 contains name, style and size of the font).
  // If Tokens parameter is not sufficient, default values are used:
  // Dialog - PLAIN - 12.
  private Font constructFont(String[] Tokens, int begin) {
    String name = "Dialog";
    int style = Font.PLAIN, size = 12;

    if (Tokens != null) {
      if (Tokens[begin] != null)
        name = Tokens[begin];
      if (Tokens[begin+1] != null)
        style = strToFontStyle(Tokens[begin+1]);
      if (Tokens[begin+2] != null)
        size = new Integer(Tokens[begin+2]).intValue();
    }
    return new Font(name,style,size);
  }



  private String formatErrorLabel(String label, String msg, String paramKey, String paramValue) {
    return
    ((label == null || label.length()==0) ? "" : label + " ")
    + ((msg == null || msg.length()==0) ? "" : msg + " ")
    + "<PARAM NAME=\""
    + ((paramKey == null) ? "null" : paramKey)
    + "\" VALUE=\""
    + ((paramValue == null) ? "null" : paramValue)
    + "\">";
  }



  // Visually distinguishes 'item'. Uses applet-level variable
  // 'selectionMethod' to determine should it recursively
  // distinguish a super-menu.
  private void selectItem(MenuItem item, boolean recursive) {

    if (item instanceof PopupNavigatorMenuItem) {
      PopupNavigatorMenuItem tmpItem = (PopupNavigatorMenuItem)item;
      tmpItem.setFont(new Font(
        (selectionFontName != null) ? selectionFontName : tmpItem.fontName,
        (selectionFontStyle != null) ? strToFontStyle(selectionFontStyle) : tmpItem.fontStyle.intValue(),
        (selectionFontSize != null) ? new Integer(selectionFontSize).intValue() : tmpItem.fontSize.intValue()
      ));
    }
    else if (item instanceof PopupNavigatorMenu) {
      PopupNavigatorMenu tmpMenu = (PopupNavigatorMenu)item;
      tmpMenu.setFont(new Font(
        (selectionFontName != null) ? selectionFontName : tmpMenu.fontName,
        (selectionFontStyle != null) ? strToFontStyle(selectionFontStyle) : tmpMenu.fontStyle.intValue(),
        (selectionFontSize != null) ? new Integer(selectionFontSize).intValue() : tmpMenu.fontSize.intValue()
      ));
    }

    if (
      recursive
      && selectionMode.equalsIgnoreCase(smRecursive)
      && item.getParent() != null
      && item.getParent() instanceof PopupNavigatorMenu
    )
      selectItem((PopupNavigatorMenu)(item.getParent()),true);

  }


  // Uses 'selectionMethod' in the same way as selectItem() does.
  private void deselectItem(MenuItem item, boolean recursive) {

    if (item instanceof PopupNavigatorMenuItem) {
      PopupNavigatorMenuItem tmpItem = (PopupNavigatorMenuItem)item;
      tmpItem.setFont(new Font(
        tmpItem.fontName,
        tmpItem.fontStyle.intValue(),
        tmpItem.fontSize.intValue()
      ));
    }
    else if (item instanceof PopupNavigatorMenu) {
      PopupNavigatorMenu tmpMenu = (PopupNavigatorMenu)item;
      tmpMenu.setFont(new Font(
        tmpMenu.fontName,
        tmpMenu.fontStyle.intValue(),
        tmpMenu.fontSize.intValue()
      ));
    }

    if (
      recursive
      && selectionMode.equalsIgnoreCase(smRecursive)
      && item.getParent()!= null
      && item.getParent() instanceof PopupNavigatorMenu
    )
      deselectItem((PopupNavigatorMenu)(item.getParent()),true);

  }



  // Recursively loads menu-tree with first 'depth' coordinates
  // contained in 'paramCoord' and inserts it as submenu of
  // 'baseMenu'. 'depth' actually contains current level of
  // recursion.
  // Possible return values:
  //   0 - No submenu.
  //   1 - Submenu without selection.
  //   2 - Selected submenu => current item should be also selected.

  private int loadMenu(Menu baseMenu, int depth) {

    int result = 0;

    // Buld non-changing part of parameter key.

    StringBuffer paramKeyStart = new StringBuffer();

    // Current depth ('depth') is excluded.
    for (int i=0; i<depth; ++i) {
      paramKeyStart.append(paramCoord[i]);
      // Delimiter coordinates in non-changing part.
      if (i+1 < depth)
        paramKeyStart.append(delimiterChar);
    }

    // Delimit non-changing and changing part.
    if (paramKeyStart.length() > 0)
      paramKeyStart.append(delimiterChar);

    String paramValue; // Result from getParameter().

    // Iterates through 'depth' level.
    paramCoord[depth] = 0;

    do { // while (paramValue != null);

      // Creating parameter key as semicolon-delimited list of coordinates
      // of current menu item. For example: "1;5;0". We just need to append
      // current depth (contained in 'depth') to precreated non-changing
      // part of key.

      String paramKey = paramKeyStart.toString() + paramCoord[depth];

      // Getting value for current menu item.
      paramValue = getParameter(paramKey.toString(),null);

      if (paramValue != null) { // Item exists.

        if (result==0)
          result = 1; // Maybe will be changed to 2.
        String[] Tokens;

        // To error that occured first.
        boolean hasErrors = false;

        try {
          Tokens = decodeParamValue(paramValue,null);
        } // try
        catch(Exception x) {
          Tokens = new String[MaxSubParameters];
          Tokens[0] = x.toString();
          //Tokens[0] = formatErrorLabel
          //  (null,x.getMessage(),paramKey.toString(),paramValue);
          hasErrors = true;
        }

        // Check for submenus.

        PopupNavigatorMenu tmpMenu = new PopupNavigatorMenu(paramValue);
        int recursiveResult = loadMenu(tmpMenu, depth + 1);

        // Has sub-menus.
        if (recursiveResult > 0) {

          try {

            // 0     1        2         3
            // Label;FontName;FontStyle;FontSize

            // Set font. defaultFontName, defaultFontStyle and defaultFontSize
            // are guarantied not to be null.
            tmpMenu.fontName = (Tokens[1] != null) ? Tokens[1] : defaultFontName;
            tmpMenu.fontStyle = new Integer(strToFontStyle((Tokens[2] != null) ? Tokens[2] : defaultFontStyle));
            tmpMenu.fontSize = new Integer((Tokens[3] != null) ? Tokens[3] : defaultFontSize);

            // Should we select it?
            if (recursiveResult==2) {
              selectItem(tmpMenu,false); // 'false' means non-recursive.
              result = recursiveResult;
            }
            else
              deselectItem(tmpMenu,false);
          }
          catch (Exception x) {
            Tokens = new String[MaxSubParameters];
            //Tokens[0] = x.getMessage();
            Tokens[0] = x.toString();
            //Tokens[0] = formatErrorLabel
            //  (null,x.getMessage(),paramKey.toString(),paramValue);
          }

          // We don't disable it even if it has errors - in order to reach child items.
          tmpMenu.setLabel(Tokens[0]);

          baseMenu.add(tmpMenu);

        } // if has sub-menus

        else { // Menu leaf (hasn't sub-menus).

          // 0     1   2     3        4         5
          // Label;URL;Frame;FontName;FontStyle;FontSize

          // No submenus - we need MenuItem instead of Menu.
          PopupNavigatorMenuItem tmpMenuItem = new PopupNavigatorMenuItem(paramValue);

          try {

            // If it's not a separator (has no label or label is
            // different from "-"), we need url and frame.
            if (Tokens[0]==null || !Tokens[0].equals("-")) {

              // Is URL null?
              if (Tokens[1] == null) {
                if (!hasErrors) {
                  if (missingURL.equalsIgnoreCase("ERROR")) {
                    Tokens[0] = formatErrorLabel(
                      null,"MISSING URL",paramKey.toString(),paramValue);
                    hasErrors = true;
                  }
                  else if (missingURL.equalsIgnoreCase("DISABLE")) {
                    tmpMenuItem.setEnabled(false);
                  }
                }
              }
              else {
                // PREMATURE DNS lookups!
                /*
                URL base;
                try {
                  if (URLBase.equalsIgnoreCase("CODEBASE"))
                    base = this.getCodeBase();
                  else if (URLBase.equalsIgnoreCase("DOCUMENT"))
                    base = this.getDocumentBase();
                  else
                    base = new URL(URLBase);
                  tmpMenuItem.url = new URL(base,Tokens[1]);
                }
                catch (MalformedURLException x) {
                  if (!hasErrors) {
                    Tokens[0] = formatErrorLabel(
                      null,"MALFORMED URL",paramKey.toString(),paramValue);
                    hasErrors = true;
                  }
                }
                */

                if (isCurrentDomain(Tokens[1])) {
                  tmpMenuItem.url = encodeURL(Tokens[1]);
                  if (tmpMenuItem.url == null) {
                    if (!hasErrors) {
                      Tokens[0] = formatErrorLabel(
                        null,"MALFORMED URL",paramKey.toString(),paramValue);
                      hasErrors = true;
                    }
                  }
                }
                else
                  tmpMenuItem.url_string = Tokens[1];

                // Set target frame.
                if (Tokens[2]==null)
                  tmpMenuItem.frame = defaultFrame;
                else
                  tmpMenuItem.frame = Tokens[2];
              } // else url isn't null

              // If label is omitted, use URL as label. We don't need to check
              // for hasErrors because it is false (Tokens[0] wouldn't be null
              // otherwise).
              if ( /*!hasErrors ||*/ Tokens[0] == null)
                Tokens[0] = Tokens[1];

            } // if not separator

            // Set font. defaultFontName, defaultFontStyle and defaultFontSize
            // are guarantied not to be null.
            tmpMenuItem.fontName = (Tokens[3] != null) ? Tokens[3] : defaultFontName;
            tmpMenuItem.fontStyle = new Integer(strToFontStyle((Tokens[4] != null) ? Tokens[4] : defaultFontStyle));
            tmpMenuItem.fontSize = new Integer((Tokens[5] != null) ? Tokens[5] : defaultFontSize);

            // Should we select item?
            if (
              (selectionMode.equalsIgnoreCase(smRecursive) || selectionMode.equalsIgnoreCase(smItem))
              && tmpMenuItem.url != null
              && tmpMenuItem.url.equals(getDocumentBase())
              /*
              && tmpMenuItem.url_string != null
              && sameAsDocumentBase(tmpMenuItem.url_string)
              */
            ) {
              selectItem(tmpMenuItem,false);
              if (selectionMode.equalsIgnoreCase(smRecursive))
                result = 2;
            }
            else
              deselectItem(tmpMenuItem,false);

          }
          catch (Exception x) {
            Tokens = new String[MaxSubParameters];
            //Tokens[0] = x.getMessage();
            Tokens[0] = x.toString();
            //Tokens[0] = formatErrorLabel
            //  (null,x.getMessage(),paramKey.toString(),paramValue);
            hasErrors = true;
          }

          tmpMenuItem.setLabel(Tokens[0]);
          if (hasErrors)
            tmpMenuItem.setEnabled(false);

          baseMenu.add(tmpMenuItem);

        } // else add menu leaf

        ++paramCoord[depth];

      } // if (paramValue != null)

    } while (paramValue != null);

    return result;

  } // loadMenu()

  /*
  // Invalid due Java's stupid parameter passing.
  private void loadLabel(
    String ParamName,
    String[] Default,
    String T,
    Font F,
    Color Fg,
    Color Bg
  ) throws Exception {

    String[] Tokens = decodeParamValue(getParameter("Label", ""),Default);
    T = Tokens[0];
    F = constructFont(Tokens,1); // Font is constructed from tokens: 1 (name), 2 (style) and 3 (size).
    Fg = strToColor(Tokens[4]);
    Bg = strToColor(Tokens[5]);

  }
  */

  // Initialize the applet.
  public void init() {
    try {
      jbInit();

      delimiterChar = getParameter("DelimiterChar", "" + delimiterChar).charAt(0);
      escapeChar = getParameter("EscapeChar", "" + escapeChar).charAt(0);
      URLBase = getParameter("URLBase",URLBase);

      defaultFontName = getParameter("DefaultFontName", defaultFontName);
      defaultFontStyle = getParameter("DefaultFontStyle", defaultFontStyle);
      defaultFontSize = getParameter("DefaultFontSize", defaultFontSize);
      defaultForegroundColor = getParameter("DefaultForegroundColor", defaultForegroundColor);
      defaultFrame = getParameter("DefaultFrame");

      String[] Tokens;

      // Setup button appearance.
      Tokens = decodeParamValue(
        getParameter("Label", ""),
        new String[] {null,defaultFontName,defaultFontStyle,
          defaultFontSize,defaultForegroundColor,defaultBackgroundColor}
      );
      if (Tokens[0] == null) {
        if (getParameter("Label",null) == null)
          Tokens[0] = "Navigate";
        else
          Tokens[0] = "";
      }
      labelText = Tokens[0];
      labelFont = constructFont(Tokens,1); // Font is constructed from tokens: 1 (name), 2 (style) and 3 (size).
      labelForeground = strToColor(Tokens[4]);
      labelBackground = strToColor(Tokens[5]);

      Tokens = decodeParamValue(
        getParameter("MouseoverLabel", ""),
        Tokens
      );
      mouseoverLabelText = Tokens[0];
      mouseoverLabelFont = constructFont(Tokens,1); // Font is constructed from tokens: 1 (name), 2 (style) and 3 (size).
      mouseoverLabelForeground = strToColor(Tokens[4]);
      mouseoverLabelBackground = strToColor(Tokens[5]);

      Tokens = decodeParamValue(
        getParameter("ClickLabel", ""),
        Tokens
      );
      clickLabelText = Tokens[0];
      clickLabelFont = constructFont(Tokens,1); // Font is constructed from tokens: 1 (name), 2 (style) and 3 (size).
      clickLabelForeground = strToColor(Tokens[4]);
      clickLabelBackground = strToColor(Tokens[5]);

      // Mouseover (hover) effect.
      Tokens = decodeParamValue(
        getParameter("ButtonStyle", ""),
        new String[] {buttonStyle,buttonHover}
      );
      buttonStyle = Tokens[0];
      buttonHover = Tokens[1];

      // Selection distinguishing.
      Tokens = decodeParamValue(
        getParameter("Selection", ""),
        new String[] {selectionMode,selectionFontName,selectionFontStyle,selectionFontSize}
      );
      selectionMode = Tokens[0];
      selectionFontName = Tokens[1];
      selectionFontStyle = Tokens[2];
      selectionFontSize = Tokens[3];

      menuActivation = getParameter("MenuActivation",menuActivation);

      // TODO: Show URL in status-bar.
      statusText = getParameter("StatusText",statusText);

      menuPosition = getParameter("MenuPosition",menuPosition);
      missingURL = getParameter("MissingURL",missingURL);

      // Load button images.
      buttonImage = getImageFromParam("Image",null);
      mouseoverButtonImage = getImageFromParam("MouseoverImage",buttonImage);
      clickButtonImage = getImageFromParam("ClickImage",mouseoverButtonImage);

      // Load button image positions.
      Tokens = decodeParamValue(
        getParameter("ImagePosition", ""),
        new String[] {buttonImagePosition,buttonImagePositionX,buttonImagePositionY}
      );
      buttonImagePosition = Tokens[0];
      buttonImagePositionX = Tokens[1];
      buttonImagePositionY = Tokens[2];

      Tokens = decodeParamValue(
        getParameter("MouseoverImagePosition", ""),
        Tokens
      );
      mouseoverButtonImagePosition = Tokens[0];
      mouseoverButtonImagePositionX = Tokens[1];
      mouseoverButtonImagePositionY = Tokens[2];

      Tokens = decodeParamValue(
        getParameter("ClickImagePosition", ""),
        Tokens
      );
      clickButtonImagePosition = Tokens[0];
      clickButtonImagePositionX = Tokens[1];
      clickButtonImagePositionY = Tokens[2];

      //buttonImagePosition = getParameter("ImagePosition",buttonImagePosition);
      //mouseoverButtonImagePosition = getParameter("MouseoverImagePosition",mouseoverButtonImagePosition);
      //clickButtonImagePosition = getParameter("ClickImagePosition",clickButtonImagePosition);

      //buttonImage = getImageFromParam("ButtonImage");
      //buttonHoverImage = getImageFromParam("ButtonHoverImage");
      //buttonDownImage = getImageFromParam("ButtonDownImage");

      // Load menu.
      loadMenu(popupMenu,0);

      enableEvents(AWTEvent.MOUSE_EVENT_MASK);

    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }



  // Component initialization.
  private void jbInit() throws Exception {
    this.setLayout(gridLayout1);
    //menuButton.setLabel("MenuButton");
    /*
    menuButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        menuButton_actionPerformed(e);
      }
    });
    */
    //this.setSize(400,300);
    //this.setSize(MenuButton.getBounds().width+2,MenuButton.getBounds().height+2);
    //menuButton.requestFocus();
    //this.add(menuButton, null);
    this.add(popupMenu);
  }

  public void showPopupMenu() {
    int x,y;
    if (menuPosition.equalsIgnoreCase("RIGHT")) {
      //x = menuButton.getBounds().width;
      x = getBounds().width;
      y = 0;
    }
    else { //if menuPosition.equalsIgnoreCase("BOTTOM")
      x = 0;
      //y = menuButton.getBounds().height;
      y = getBounds().height;
    }
    //popupMenu.show(menuButton,x,y);
    popupMenu.show(this,x,y);
  }

  public boolean action(Event evt, Object arg) {

    //if (evt.target instanceof Button)
    //  showPopupMenu();
    //if (evt.target instanceof Applet)
    //  showPopupMenu();
    //else
    if (evt.target instanceof PopupNavigatorMenuItem) {
      PopupNavigatorMenuItem source = (PopupNavigatorMenuItem)(evt.target);
      switch(evt.id) {
        case Event.ACTION_EVENT:
          navigate(source);
          return true;
          //break;
        // PopupMenu currently doesn't support mouse events.
        //case Event.MOUSE_ENTER:
        //  showStatus(source.url.toString());
        //  break;
        default:
          return false;
      }
    }

    return false;

    // Because of stupid compiler.
    //return true;
  }


  protected void processMouseEvent(MouseEvent e) {
    super.processMouseEvent(e);
    switch (e.getID()) {
      case MouseEvent.MOUSE_ENTERED:
        mouseIn = true;
        if (statusText != null)
          showStatus(statusText);
        if (menuActivation.equalsIgnoreCase("MOUSEOVER"))
          showPopupMenu();
        // TODO: Check is repainting is necessary.
        repaint();
        break;
      case MouseEvent.MOUSE_EXITED:
        if (statusText != null)
          showStatus("");
        //mouseDown = false;
        mouseIn = false;
        repaint();
        break;
      case MouseEvent.MOUSE_PRESSED:
        mouseDown = true; // mouseIn is irelevant.
        repaint();
        break;
      case MouseEvent.MOUSE_RELEASED:
        mouseDown = false; // mouseIn is irelevant.
        if (
          e.getX() >= getBounds().x
          && e.getY() >= getBounds().y
          && e.getX() <= getBounds().x + getBounds().width
          && e.getY() <= getBounds().y + getBounds().height
        )
          showPopupMenu();
        else
          mouseIn = false; // Some browsers could avoid delivering MOUSE_EXITED event.
        repaint();
        break;
      case MouseEvent.MOUSE_CLICKED:
        break;
    }
  }


  //Get Applet information
  public String getAppletInfo() {
    return "PopupNavigatorApplet by Branko Dimitrijevic";
  }



  //Get parameter info
  //public String[][] getParameterInfo() {
  //  return null;
  //}



  //void menuButton_actionPerformed(ActionEvent e) {
  //  popupMenu.show(menuButton,0,menuButton.getBounds().height);
  //}



  private void navigate(PopupNavigatorMenuItem item) {

    if (selectionMode.equalsIgnoreCase(smRecursive)) {
      if (oldSelection != null)
        deselectItem(oldSelection,true);
      oldSelection = item;
      selectItem(item,true);
    }
    else if (selectionMode.equalsIgnoreCase(smItem)) {
      if (oldSelection != null)
        deselectItem(oldSelection,false);
      oldSelection = item;
      selectItem(item,false);
    }

    if (item.url == null)
      item.url = encodeURL(item.url_string);

    if (item.frame == null)
      getAppletContext().showDocument(item.url);
    else
      getAppletContext().showDocument(item.url,item.frame);

  } // navigate()

  //void onNavigationStart(ActionEvent e) {
  //  PopupNavigatorMenuItem source = (PopupNavigatorMenuItem)(e.getSource());
  //  navigate(source);
  //}

  //private void paintImage(Graphics g, Image img, String pos, String posX, String posY) {

  //  if buttonImagePosition.equalsIgnoreCase(bipAbsolute)

  //  g.drawImage(
  //    img,
  //    new Integer(posX).intValue(),
  //    new Integer(posY).intValue(),
  //    this
  //  );
  //}

  // Paints label.
  private void paintLabelAndImage(
    Graphics g,
    Color background,
    Color foreground,
    Font f,
    String text,
    Image img,
    String pos,  // ABSOLUTE, CENTER, RIGHT,...
    String posX,
    String posY
  ) {

    // Draw background.
    g.setColor(background);
    g.fillRect(0,0,getBounds().width,getBounds().height);

    g.setFont(f);
    FontMetrics FM = g.getFontMetrics(g.getFont());

    int appletWidth = getBounds().width;
    int appletHeight = getBounds().height;

    // TODO: Label position.

    // Calculate label coordinates.
    int labelWidth;
    if (text == null)
      labelWidth = 0;
    else
      labelWidth = FM.stringWidth(text);
    int labelX = (appletWidth  - labelWidth) / 2;
    int labelY = (appletHeight - FM.getDescent() + FM.getAscent()) / 2;

    // Calculate image, possibly change label coordinates and draw image.
    if (img != null) {

      int imageWidth = img.getWidth(this);
      int imageHeight = img.getHeight(this);

      // Image loaded?
      if (imageWidth > 0 && imageHeight > 0) {

        int imageX,imageY;

        if (pos.equalsIgnoreCase(bipAbsolute)) {
          imageX = new Integer(posX).intValue();
          if (imageX < 0)
            imageX = appletWidth + imageX - imageWidth;
          imageY = new Integer(posY).intValue();
          if (imageY < 0)
            imageY = appletHeight + imageY - imageHeight;
        }
        else if (pos.equalsIgnoreCase(bipCenter)) {
          imageX = (appletWidth - imageWidth) / 2;
          imageY = (appletHeight - imageHeight) / 2;
        }
        else if (pos.equalsIgnoreCase(bipLeft) || pos.equalsIgnoreCase(bipRight)) {
          int a = new Integer(posX).intValue();
          if (pos.equalsIgnoreCase(bipLeft)) {
            labelX += a/2;
            imageX = labelX - a - imageWidth;
          }
          else { // pos.equalsIgnoreCase(bipRight)
            labelX -= a/2;
            imageX = labelX + labelWidth + a;
          }
          imageY = (appletHeight - imageHeight) / 2;
        }
        else if (pos.equalsIgnoreCase(bipTop) || pos.equalsIgnoreCase(bipBottom)) {
          int a = new Integer(posX).intValue();
          if (pos.equalsIgnoreCase(bipTop)) {
            labelY += a/2 ;
            imageY = labelY - FM.getAscent() - a - imageHeight;
          }
          else { //pos.equalsIgnoreCase(bipTop);
            labelY -= a/2;
            imageY = labelY + FM.getDescent() + a;
          }
          imageX = (appletWidth - imageWidth) / 2;
        }
        else { // For robustness.
          imageX = 0;
          imageY = 0;
        }

        // Draw image.
        g.drawImage(img,imageX,imageY,this);

      } // if image loaded

    } // if (img != null)

    // Draw label.
    if (text != null) {
      g.setColor(foreground);
      g.drawString(
        text,
        labelX,
        labelY
      );
    }  

  }

  private void paint3dRect(
    Graphics g,
    int x,
    int y,
    int w,
    int h,
    Color C1, // Light color.
    Color C2, // Dark color.
    boolean raised
  ) {
    if (!raised) {
      Color Tmp = C1;
      C1 = C2;
      C2 = Tmp;
    }
    g.setColor(C1);
    g.drawLine(x,y,w,y);
    g.drawLine(x,y,x,h);
    g.setColor(C2);
    g.drawLine(w,y,w,h);
    g.drawLine(x,h,w,h);
  }

  private void paintThinBorder(Graphics g, boolean raised) {
    paint3dRect(
      g,
      0,
      0,
      getBounds().width - 1,
      getBounds().height - 1,
      Color.white,
      Color.gray,
      raised
    );
  }

  private void paintNormalBorder(Graphics g, boolean raised) {
    paint3dRect(
      g,
      1,
      1,
      getBounds().width - 2,
      getBounds().height - 2,
      Color.lightGray,
      Color.gray,
      raised
    );
    paint3dRect(
      g,
      0,
      0,
      getBounds().width - 1,
      getBounds().height - 1,
      Color.white,
      Color.darkGray,
      raised
    );
  }

  private void paintThickBorder(Graphics g, boolean raised) {
    paint3dRect(
      g,
      2,
      2,
      getBounds().width - 3,
      getBounds().height - 3,
      Color.lightGray,
      Color.gray,
      raised
    );
    paint3dRect(
      g,
      1,
      1,
      getBounds().width - 2,
      getBounds().height - 2,
      Color.white,
      Color.darkGray,
      raised
    );
    g.setColor(Color.black);
    g.drawRect(0,0,getBounds().width-1,getBounds().height-1);
  }

  private void paintButtonBorder(Graphics g, boolean raised) {
    if (buttonStyle.equalsIgnoreCase(bsSemiflat))
      paintThinBorder(g,raised);
    else if (buttonStyle.equalsIgnoreCase(bsNormal))
      paintNormalBorder(g,raised);
  }

  private void paintHoverBorder(Graphics g, boolean raised) {
    if (buttonStyle.equalsIgnoreCase(bsFlat))
      paintThinBorder(g,raised);
    else if (buttonStyle.equalsIgnoreCase(bsSemiflat))
      paintNormalBorder(g,raised);
    else if (buttonStyle.equalsIgnoreCase(bsNormal))
      paintThickBorder(g,raised);
  }

  // TODO: Support for oval button border.

  public void paint(Graphics g) {
    //g.drawLine(1,1,10,10);
    //g.drawString("history", 10, 10);

    // Draw background.
    //g.setColor(labelBackground);
    //g.fillRect(0,0,getBounds().width,getBounds().height);

    // Draw label.
    //g.setFont(labelFont);
    //g.setColor(labelForeground);
    //FontMetrics FM = g.getFontMetrics(g.getFont());
    //g.drawString(
    //  labelText,
    //  (getBounds().width - FM.stringWidth(labelText)) / 2,
    //  (getBounds().height - FM.getDescent() + FM.getAscent()) / 2
    //);

    // Draw border.
    if (mouseDown) {
      paintLabelAndImage(
        g,clickLabelBackground,clickLabelForeground,clickLabelFont,clickLabelText,
        clickButtonImage,clickButtonImagePosition,clickButtonImagePositionX,clickButtonImagePositionY
      );
      if (buttonHover.equalsIgnoreCase(bhHover))
        paintHoverBorder(g,false);
      else
        paintButtonBorder(g,false);
    }
    else if (mouseIn) {
      paintLabelAndImage(
        g,mouseoverLabelBackground,mouseoverLabelForeground,mouseoverLabelFont,mouseoverLabelText,
        mouseoverButtonImage,mouseoverButtonImagePosition,mouseoverButtonImagePositionX,mouseoverButtonImagePositionY
      );
      if (buttonHover.equalsIgnoreCase(bhHover))
        paintHoverBorder(g,true);
      else
        paintButtonBorder(g,true);
    }
    else {
      paintLabelAndImage(
        g,labelBackground,labelForeground,labelFont,labelText,
        buttonImage,buttonImagePosition,buttonImagePositionX,buttonImagePositionY
      );
      paintButtonBorder(g,true);
    }
    //paintThickBorder(g,!mouseDown);
    //paintImage(g,buttonImage,buttonImagePosition,buttonImagePositionX,buttonImagePositionY);

  } // paint

} // SiteMenuBarApplet

