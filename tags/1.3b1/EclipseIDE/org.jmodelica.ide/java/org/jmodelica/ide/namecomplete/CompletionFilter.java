package org.jmodelica.ide.namecomplete;


/**
 * When doing name completion, the users should be allowed to type e.g. .ConInt
 * and get a match for the class ContinuousIntegrator.
 * 
 * This class determines matching of this kind of partial names with full
 * identifiers.
 * 
 * More details in the behaviour of this class are regarded as documented
 * through it's test cases.
 * 
 * @author philip
 * 
 */
public class CompletionFilter {

    public final String filter;

    public CompletionFilter(String filter) {
        this.filter = filter;
    }
    
    /**
     * Matches a {@link CompletionFilter} to a name. 
     * E.g. "AB_CcDd" matches "AaaBbbb_CccDdddEeee_Ffff".
     * 
     * @param name name to match
     * @return true if matches
     */
    public boolean matches(String name) {
        
        String[] parts_a = filter.split("_");
        String[] parts_n = name.split("_");
        
        for (int i = 0; i < parts_a.length; i++) 
            if (!matchesCamel(parts_a[i], parts_n[i], 0, 0))
                return false;
        
        return true;
    }
    
    
    /**
     * @return true for e.g. "ConInt" and "ContinuousIntegrator".   
     */
    protected static boolean matchesCamel(
            String filter, 
            String name, 
            int i, 
            int j) {
        
        if (i >= filter.length())
            return true;
        
        if (j >= name.length())
            return false;
        
        char    cf      = filter.charAt(i), 
                cn      = name.charAt(j);
        boolean f = Character.isLowerCase(cf),
                n = Character.isLowerCase(cn),
                F = !f,
                N = !n;
        
        if (f && n || F && N)
            return 
                cf == cn && 
                matchesCamel(filter, name, i+1, j+1);
        
        if (f && N)
            return 
               i == 0 && // e.g. 'contin' should match 'ContinousIntegrator' 
               cf == Character.toLowerCase(cn) && 
               matchesCamel(filter, name, i+1, j+1);
        
        if (F && n)
           return matchesCamel(filter, name, i, j + 1);
        
        throw new RuntimeException(
            "Impossible exectution path");
    }
    
    public int length() {
        return filter.length();
    }
}
