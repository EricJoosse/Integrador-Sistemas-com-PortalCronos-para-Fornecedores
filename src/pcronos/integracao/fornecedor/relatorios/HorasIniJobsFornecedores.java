package pcronos.integracao.fornecedor.relatorios;

import java.util.Map.Entry;
import pcronos.integracao.fornecedor.Fornecedor;
import pcronos.integracao.fornecedor.FornecedorRepositorio;
import pcronos.integracao.fornecedor.Utils;

public class HorasIniJobsFornecedores {

	public static void main(String[] args) throws Exception {
		System.out.println(Utils.rpad("ID", 4) + " " + Utils.rpad("Fornecedor", 29) + " "
				+ Utils.rpad("Minuto Atual", 13) + " " + Utils.rpad("Minuto v 3.1.0 e maior", 6));
		System.out.println(Utils.rpad("==", 4) + " " + Utils.rpad("==========", 29) + " "
				+ Utils.rpad("============", 13) + " " + Utils.rpad("======================", 6));
		System.out.println(Utils.rpad("", 4) + " " + Utils.rpad("", 29) + " "
				+ Utils.rpad("(hh:mm:ss)", 13) + " " + Utils.rpad("(hh:mm:ss)", 6));
		System.out.println();

		for (Entry<Integer, Fornecedor> entry : FornecedorRepositorio.hashMap.entrySet()) {
			// String key = entry.getKey().toString();
			Object value = entry.getValue();
			// System.out.println("key = " + key);
			// System.out.println("NomeFantasiaEmpresa = " +
			// ((Fornecedor)value).NomeFantasiaEmpresa);
			// System.out.println("versaoIntegrador = " +
			// ((Fornecedor)value).versaoIntegrador);

			Integer idFornecedor = ((Fornecedor) value).IdFornecedor;
			FornecedorRepositorio fRep = new FornecedorRepositorio();
			Fornecedor f = fRep.getFornecedor(idFornecedor);			
			
			
			String minutoAgendamentoFuturo = "";
			String segundoAgendamentoFuturo = "";
			
			try 
			{
				// No caso do servidor de monitoramento:
				if (idFornecedor == null || idFornecedor == -1)
				{
					minutoAgendamentoFuturo = Byte.toString(Utils.calcularMinutoAgendamento(false, -1));
					segundoAgendamentoFuturo = "47";
				}
				else if (f.IsServicoNuvem)
				{
					minutoAgendamentoFuturo = Integer.toString(f.SequenciaInstanciaNuvem);
					segundoAgendamentoFuturo = "0";
				}
				else if (!f.IsServicoNuvem)
				{
					minutoAgendamentoFuturo = Byte.toString(Utils.calcularMinutoAgendamento(f.IsServicoNuvem, idFornecedor));
					segundoAgendamentoFuturo = "0";
				}
				else
					throw new Exception("Situa��o imprevista");
			
			} 
			catch (Exception ex) {
				minutoAgendamentoFuturo = ex.getMessage();
			}

			try
			{
				if (Integer.parseInt(minutoAgendamentoFuturo) < 10)
					minutoAgendamentoFuturo = "0" + minutoAgendamentoFuturo;

				if (Integer.parseInt(segundoAgendamentoFuturo) < 10)
					segundoAgendamentoFuturo = "0" + segundoAgendamentoFuturo;
			}
			catch (Exception ex) { }


			
			
			
			String minutoAgendamentoAtual = "";
			String segundoAgendamentoAtual = "";
			
            if (f.versaoIntegrador.compareTo("3.1.0") >= 0 || f.versaoIntegrador.compareTo("3.1") >= 0)
            {
				minutoAgendamentoAtual = minutoAgendamentoFuturo;
				segundoAgendamentoAtual = segundoAgendamentoFuturo;
            }
            else if (f.IsServicoNuvem)
            {
        		if (f.NomeFantasiaEmpresa.equals("Marizpan"))
        			minutoAgendamentoAtual = "04";
        		else if (f.NomeFantasiaEmpresa.equals("Atacamax"))
        			minutoAgendamentoAtual = "11";
        		else 
        			minutoAgendamentoAtual = "01";
        		
        		segundoAgendamentoAtual = "47";
            }
            else
            {
				minutoAgendamentoAtual = "04";
        		segundoAgendamentoAtual = "47";
            }

            
			System.out.println(Utils.rpad(Utils.replaceNull(idFornecedor).toString(), 4) + " "
						+ Utils.rpad(Utils.replaceNull(((Fornecedor) value).NomeFantasiaEmpresa).replace("�ncia","."), 29) + " "
						+ Utils.rpad(("00:" + Utils.replaceNull(minutoAgendamentoAtual) + ":" + segundoAgendamentoAtual), 13) + " "
						+ Utils.rpad(("00:" + Utils.replaceNull(minutoAgendamentoFuturo) + ":" + segundoAgendamentoFuturo), 6));
		}
	}

}
