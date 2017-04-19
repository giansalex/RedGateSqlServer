SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ContactoCons]
@RucE nvarchar(11),
@Cd_Prv char (7),
@msj varchar(100) output,
@TipCons int

as

begin
	--Consulta general--
	if(@TipCons=0)
	begin
		--select ID_Gen, isnull(ApPat,'')+' '+ isnull(ApMat,'')+', '+isnull(Nom,'') as NombreCompleto,Direc,Telf,Correo,Cargo,IB_Prin,Estado from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv
		select *, isnull(ApPat,'')+' '+ isnull(ApMat,'')+', '+isnull(Nom,'') as NombreCompleto from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv
		set @msj = ''
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select isnull(ApPat,'')+' '+ isnull(ApMat,'')+', '+Nom ,ID_Gen,Nom from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select ID_Gen,RucE,Cd_Prv,ApPat,ApMat,Nom,Direc,Telf,Correo,Cargo,Estado,CA01,CA02,CA03,CA04,CA05 from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv and Estado =1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select ID_Gen,ID_Gen, isnull(ApPat,'')+' '+ isnull(ApMat,'')+', '+Nom from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv and Estado =1
				end
end
print @msj



-- Leyenda --
-- PP : 2010-02-17 : <Creacion del procedimiento almacenado>

GO
