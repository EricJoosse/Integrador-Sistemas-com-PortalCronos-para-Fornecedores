package pcronos.integracao.fornecedor.annotations;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import javax.validation.Constraint;
import javax.validation.Payload;
import pcronos.integracao.fornecedor.validators.ConfigInstaladorIntegradorNuvemValidator;


@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Constraint(validatedBy = ConfigInstaladorIntegradorNuvemValidator.class)
public @interface ValidConfigInstaladorIntegradorNuvem 
{
   String message() default "Erro interno! Mensagem n�o definida!";
   Class<?>[] groups() default { };
   Class<? extends Payload>[] payload() default { };
}
