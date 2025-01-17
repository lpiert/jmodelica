/*
    Copyright (C) 2015 Modelon AB

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
package org.jmodelica.util.logging;

import java.util.ArrayList;

import org.jmodelica.util.logging.units.LoggingUnit;

/**
 * A Memory logger takes a log level and a parent logger. Messages written to
 * this log is normally forwarded to the parent logger. However it also records
 * all messages. It is then possible, at a later instance, to resend all
 * messages with the supplied log level.
 * This is useful for external compilation processes where we want to log the
 * log if it fails but not otherwise. This class also has the advantage that it
 * continuously prints the log for lower levels. Additionally it only prints
 * it once, even if the printCache() method is called.
 */
public class MemoryLogger extends ModelicaLogger {
    
    private final ModelicaLogger parent;
    private final Level postPrintLevel;
    
    private final ArrayList<LoggedUnit> cache = new ArrayList<LoggedUnit>();
    
    public MemoryLogger(ModelicaLogger parent, Level postPrintLevel) {
        super(parent.getLevel());
        this.parent = parent;
        this.postPrintLevel = postPrintLevel;
    }

    @Override
    public void close() {
        cache.clear();
    }

    @Override
    protected void write(Level level, Level alreadySentLevel, LoggingUnit logMessage) {
        parent.write(level, alreadySentLevel, logMessage);
        if (!postPrintLevel.shouldLog(level)) {
            cache.add(new LoggedUnit(level, logMessage));
        }
    }

    /**
     * Print the cached messages to the post print level.
     */
    public void printCache() {
        for (LoggedUnit unit : cache) {
            parent.write(postPrintLevel, unit.level, unit.message);
        }
        cache.clear();
    }
    
    private static class LoggedUnit {
        private final Level level;
        private final LoggingUnit message;
        
        private LoggedUnit(Level level, LoggingUnit message) {
            this.level = level;
            this.message = message;
        }
    }

}
