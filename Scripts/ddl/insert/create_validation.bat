Error: freemarker.core.InvalidReferenceException: The following has evaluated to null or missing:
==> validations  [in template "msdos/pgsqlProcedureInsert.ftl" at line 22, column 8]

----
Tip: If the failing expression is known to legally refer to something that's sometimes null or missing, either specify a default value like myOptionalVar!myDefault, or use <#if myOptionalVar??>when-present<#else>when-missing</#if>. (These only cover the last step of the expression; to cover the whole expression, use parenthesis: (myOptionalVar.foo)!myDefault, (myOptionalVar.foo)??
----

----
FTL stack trace ("~" means nesting-related):
	- Failed at: #list validations as validationName  [in template "msdos/pgsqlProcedureInsert.ftl" at line 22, column 1]
----