package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class AuthUtil {
    private AuthUtil() {}
    public static Integer userId(HttpServletRequest req) {
        HttpSession s=req.getSession(false); return s==null?null:(Integer)s.getAttribute("userId");
    }
    public static String role(HttpServletRequest req) {
        HttpSession s=req.getSession(false); return s==null?null:(String)s.getAttribute("userRole");
    }
    public static boolean isAdmin(HttpServletRequest req) { return "ADMIN".equals(role(req)); }
}
