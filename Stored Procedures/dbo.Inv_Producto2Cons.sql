SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons]
@RucE nvarchar(11),
@TipCons int,
@TipProd int = null,
@msj varchar(100) output
as

begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,Cta3,Cta4,Cta5,Cta6,Cta7,Cta8,CodCo1_,CodCo2_,CodCo3_,CodBarras,FecCaducidad,
			case(isnull(len(convert(varbinary(255),img)),0)) when 0 then convert(bit, 0) else convert(bit,1) end as ContImg,Img,
			StockMin,StockMax,StockAlerta,StockActual,StockCot,StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,
			Cd_CGP,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
		from Producto2 where RucE = @RucE and Estado =1 --Epsilower
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			if(@RucE = '20538349730')
			select CodCo1_+' | '+Nombre1,Cd_Prod,Nombre1 from Producto2 where Estado=1 and  RucE = @RucE
			else
			select Cd_Prod+' | '+Nombre1,Cd_Prod,Nombre1 from Producto2 where Estado=1 and  RucE = @RucE
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin			
				select Cd_Prod,Nombre1,Descrip,Cd_CL,Cd_CLS,Cd_CLSS  from Producto2 
				where Estado=1 and  RucE = @RucE
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					if(@TipProd=0)
					begin
			if(@RucE = '20538349730')
					select Cd_Prod,CodCo1_,Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE and IB_PT=1
			else
					select Cd_Prod,isnull(CodCo1_, Cd_Prod),Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE and IB_PT=1
					end
					else if (@TipProd=1)
					begin
			if(@RucE = '20538349730')
					select Cd_Prod,CodCo1_,Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE and IB_MP=1
			else
					select Cd_Prod,isnull(CodCo1_, Cd_Prod),Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE and IB_MP=1
					end
					else
			if(@RucE = '20538349730')
					select Cd_Prod,CodCo1_,Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE
			else
					select Cd_Prod,isnull(CodCo1_, Cd_Prod),Nombre1,Cd_CL,Cd_CLS,Cd_CLSS from Producto2 where Estado=1 and  RucE = @RucE
				end
end
print @msj
-- Leyenda --
-- PP : 2010-02-23 : <Creacion del procedimiento almacenado>

GO
