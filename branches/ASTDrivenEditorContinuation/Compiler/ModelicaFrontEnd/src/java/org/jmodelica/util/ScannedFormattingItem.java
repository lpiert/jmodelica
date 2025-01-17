package org.jmodelica.util;

/**
 * An object that holds the value and position of some sort of formatting. It can, for example, hold the position,
 * extent and actual string representation of a comment or white spaces forming indentation.
 */
public class ScannedFormattingItem extends FormattingItem implements Comparable<ScannedFormattingItem> {
	protected int startLine;
	protected int startColumn;
	protected int endLine;
	protected int endColumn;

	/**
	 * Creates a <code>ScannedFormattingItem</code>.
	 * @param type the type of this item.
	 * @param data the string representation of what this item holds, such as an actual comment.
	 * @param startLine the line in the source code at which this item begins.
	 * @param startColumn the column in the source code at which this item begins.
	 * @param endLine the line in the source code at which this item ends. 
	 * @param endColumn the column in the source code at which this item ends.
	 */
	public ScannedFormattingItem(Type type, String data, int startLine, int startColumn,
			int endLine, int endColumn) {
		super(type, data);
		this.startLine = startLine;
		this.startColumn = startColumn;
		this.endLine = endLine;
		this.endColumn = endColumn;
	}

	/**
	 * Creates a <code>ScannedFormattingItem</code>. The end line and end column is calculated from the text data.
	 * @param type the type of this item
	 * @param data the string representation of what this item holds, such as an actual comment.
	 * @param startLine the line in the source code at which this item begins.
	 * @param startColumn the column in the source code at which this item begins.
	 */
	public ScannedFormattingItem(Type type, String data, int startLine, int startColumn) {
		this(type, data, startLine, startColumn, startLine + countLines(data),
				(countLines(data) == 0 ? startColumn + data.length() - 1 : countColumnsOnLastLine(data)));
	}
	
	/**
	 * Gets the line number of where the start of this symbol was found when it was scanned.
	 * @return the line at which this symbol started when it was scanned.
	 */
	public int getStartLine() {
		return startLine;
	}
	
	/**
	 * Gets the column number of where the start of this symbol was found when it was scanned.
	 * @return the column at which this symbol started when it was scanned.
	 */
	public int getStartColumn() {
		return startColumn;
	}
	
	/**
	 * Gets the line number of where the end of this symbol was found when it was scanned.
	 * @return the line at which this symbol ended when it was scanned.
	 */
	public int getEndLine() {
		return endLine;
	}
	
	/**
	 * Gets the column number of where the end of this symbol was found when it was scanned.
	 * @return the column at which this symbol ended when it was scanned.
	 */
	public int getEndColumn() {
		return endColumn;
	}
	
	@Override
	public Adjacency getAdjacency(FormattingItem otherItem) {
		if (!otherItem.isScanned()) {
			return Adjacency.NONE;
		}
		ScannedFormattingItem otherScannedItem = (ScannedFormattingItem) otherItem;

		if ((startLine == otherScannedItem.endLine && startColumn == otherScannedItem.endColumn + 1) ||
				(otherScannedItem.endsWithLineBreak() && startLine == otherScannedItem.endLine + 1 && startColumn == 1)) {
			return Adjacency.FRONT;
		} else if (endLine == otherScannedItem.startLine && endColumn + 1 == otherScannedItem.startColumn ||
				(this.endsWithLineBreak() && endLine + 1 == otherScannedItem.startLine && otherScannedItem.startColumn == 1)) {
			return Adjacency.BACK;
		}

		return Adjacency.NONE;
	}
	
	protected boolean endsWithLineBreak() {
		return (type == Type.LINE_BREAK || data.endsWith("\r") || data.endsWith("\n"));
	}

	@Override
	public RelativePosition getFrontRelativePosition(int line, int column) {
		if ((endLine == line && endColumn + 1 == column) || (column == 1 && endLine + 1 == line && endsWithLineBreak())) {
			return RelativePosition.FRONT_ADJACENT;
		} else if (endLine > line || (endLine == line && endColumn + 1 > column)) {
			return RelativePosition.AFTER;
		}
		
		return RelativePosition.BEFORE;
	}
	
	@Override
	public RelativePosition getBackRelativePosition(int line, int column) {
		if (startLine < line || (startLine == line && startColumn < column + 1)) {
			return RelativePosition.BEFORE;
		} else if (startLine == line && startColumn == column + 1) {
			return RelativePosition.BACK_ADJACENT;
		}
		return RelativePosition.AFTER;
	}
	
	@Override
	public ScannedFormattingItem mergeItems(Adjacency where, FormattingItem otherItem) {
		if (where == Adjacency.NONE || otherItem.type == Type.EMPTY) {
			return this;
		}
		
		MixedFormattingItem mergedItems = new MixedFormattingItem(this);
		return mergedItems.mergeItems(where, otherItem);
	}

	ScannedFormattingItem[] splitAfterFirstLineBreak() {
		ScannedFormattingItem[] result = new ScannedFormattingItem[1];
		result[0] = this;
		return result;
	}

	/**
	 * Gets information about this <code>ScannedFormattingItem</code> in an XML styled text string, which might be
	 * usable when debugging.
	 * @param printData if true, the method also prints the data of the item, otherwise the tag is short hand
	 * closed.
	 * @return a String with information about this item's type, starting position, ending position and if
	 * <code>printData</code> is true also the actual string data this formatting item holds.
	 */
	public String getInformationString(boolean printData) {
		StringBuilder stringBuilder = new StringBuilder("<formattingitem type=\"" + type +
				"\" startline=\"" + startLine +
				"\" startcolumn=\"" + startColumn +
				"\" endline=\"" + endLine +
				"\" endcolumn=\"" + endColumn +
				"\"");

		if (printData) {
			stringBuilder.append(">" + toString() + "</formattingitem>");
		} else {
			stringBuilder.append(" />");
		}

		return stringBuilder.toString();
	}
	
	/**
	 * Gets information about this <code>ScannedFormattingItem</code> in an XML styled text string, which might be
	 * usable when debugging. Identical to calling getInformationString(false).
	 * @return a String with information about this item's type, starting position and ending position.
	 */
	public String getInformationString() {
		return getInformationString(false);
	}

	/**
	 * Compares this scanned formatting item with another one to determine which item appeared first when scanned,
	 * and if both items started at the same position, then which one ended first. If this item appeared first (or
	 * if both items started at the same position, but this item ended first), then a negative value is returned.
	 * If this item started after the other item (or if both items started at the same position, but this item
	 * ended last), then a positive value is returned. Otherwise 0 is returned.
	 * @return a negative value if this item started first (or if both items started at the same position, but this
	 * item ended first). A positive value if this item started after the other item (or if both items started at
	 * the same position, but this item ended last). Otherwise, the value 0.
	 */
	public int compareTo(ScannedFormattingItem otherItem) {
		int result = this.getStartLine() - otherItem.getStartLine();
		if (result == 0) {
			result = this.getStartColumn() - otherItem.getStartColumn();
			if (result == 0) {
				result = this.getEndLine() - otherItem.getEndLine();
				if (result == 0) {
					result = this.getEndColumn() - otherItem.getEndColumn();
				}
			}
		}
		return result;
	}

	public boolean equals(Object otherObject) {
		if (otherObject instanceof ScannedFormattingItem) {
			return (this.compareTo((ScannedFormattingItem) otherObject) == 0);
		}

		return false;
	}
	
	@Override
	public DefaultFormattingItem copyWhitepacesFromFormatting() {
		if (type == FormattingItem.Type.NON_BREAKING_WHITESPACE || type == FormattingItem.Type.LINE_BREAK) {
			return new DefaultFormattingItem(data);
		}
		
		return new EmptyFormattingItem();
	}

	/**
	 * Checks whether <code>line</code> and <code>column</code> are equal to this
	 * <code>ScannedFormattingItem</code>'s starting position.
	 * @param line the line for which to determine if its equal to this item's starting position.
	 * @param column the column for which to determine if its equal to this item's starting position.
	 * @return true if <code>line</code> and <code>column</code> are equal to this
	 * <code>ScannedFormattingItem</code>'s starting position. Otherwise false.
	 */
	public boolean atStart(int line, int column) {
		return (getStartLine() == line && getStartColumn() == column);
	}

	/**
	 * Checks whether <code>line</code> and <code>column</code> are equal to this
	 * <code>ScannedFormattingItem</code>'s ending position.
	 * @param line the line for which to determine if its equal to this item's ending position.
	 * @param column the column for which to determine if its equal to this item's ending position.
	 * @return true if <code>line</code> and <code>column</code> are equal to this
	 * <code>ScannedFormattingItem</code>'s ending position. Otherwise false.
	 */
	public boolean atEnd(int line, int column) {
		return (getEndLine() == line && getEndColumn() == column);
	}
	
	@Override
	public final boolean isScanned() {
		return true;
	}
	
	@Override
	public boolean isScannedMixed() {
		return false;
	}
	
	@Override
	public final boolean isEmptyDefault() {
		return false;
	}
	
	@Override
	public FormattingItem combineItems(ScannedFormattingItem otherItem) {
		FormattingItem newItem = null;
		Adjacency adjacency = getAdjacency(otherItem);
		if (adjacency == Adjacency.FRONT) {
			/* Front */
			if (type == Type.NON_BREAKING_WHITESPACE && otherItem.type == Type.NON_BREAKING_WHITESPACE) {
				String newData = otherItem.data + data;
				newItem = new ScannedFormattingItem(Type.NON_BREAKING_WHITESPACE, newData, otherItem.getStartLine(), otherItem.getStartColumn(),
						getEndLine(), otherItem.getStartColumn() + newData.length() - 1);
			} else {
				newItem = new MixedFormattingItem(this);
				newItem = newItem.mergeItems(Adjacency.FRONT, otherItem);
			}
		} else if (adjacency == Adjacency.BACK) {
			/* Back */
			if (type == Type.NON_BREAKING_WHITESPACE && otherItem.type == Type.NON_BREAKING_WHITESPACE) {
				String newData = data + otherItem.data;
				newItem = new ScannedFormattingItem(Type.NON_BREAKING_WHITESPACE, newData, getStartLine(), getStartColumn(),
						getEndLine(), getStartColumn() + newData.length() - 1);
			} else {
				newItem = new MixedFormattingItem(this);
				newItem = newItem.mergeItems(Adjacency.BACK, otherItem);
			}
		} else if (getBackRelativePosition(otherItem.getStartLine(), otherItem.getStartColumn()) == RelativePosition.BEFORE &&
				getFrontRelativePosition(otherItem.getStartLine(), otherItem.getStartColumn()) == RelativePosition.AFTER) {
			newItem = new MixedFormattingItem(this);
			newItem = ((MixedFormattingItem) newItem).insertItem(otherItem);
		} /* Else unrelated */
		
		return newItem;
	}
	
	protected int getOffset(int line, int column) {
		int currentLine = getStartLine();
		int currentColumn = getStartColumn();
		int offset = 0;
		
		if (line < currentLine || (line == currentLine && column < currentColumn)) {
			return -1; // Trying to offset out of bounds (before this item).
		}

		while (currentLine < line) {
			if (offset >= data.length()) {
				return -1; // Invalid column.
			}
			
			switch (data.charAt(offset++)) {
			case '\r':
				if (offset < data.length() && data.charAt(offset) == '\n') {
					++offset;
				}
			case '\n':
				++currentLine;
				currentColumn = 1;
				break;
			default:
				++currentColumn;
				break;
			}
		}
		offset = offset + (column - currentColumn);
		
		if (offset >= data.length()) {
			return -1; // Trying to offset out of bounds (after this item).
		}
		
		return offset;
	}
	
	@Override
	public int spanningLines() {
		return (getEndLine() - getStartLine()) + (endsWithLineBreak() ? 1 : 0);
	}
	
	@Override
	public int spanningColumnsOnLastLine() {
		if (endsWithLineBreak()) {
			return 0;
		}

		return (getStartLine() == getEndLine() ? (getEndColumn() - getStartColumn() + 1) : getEndColumn());
	}
	
	@Override
	public boolean inside(int line, int column) {
		return ((line > getStartLine() || (line == getStartLine() && column >= getStartColumn())) &&
				(line < getEndLine() || (line == getEndLine() && column <= getEndColumn())));
	}

	@Override
	public void offsetItemAfter(int line, int column, int byLines, int byColumnsOnLastLine) {
		if (line < getStartLine() || (line == getStartLine() && column <= getStartColumn())) {
			if (line == getStartLine()) {
				startColumn += byColumnsOnLastLine;
				if (getStartLine() == getEndLine()) {
					endColumn += byColumnsOnLastLine;
				}
			}
			startLine += byLines;
			endLine += byLines;
		}
	}
}
