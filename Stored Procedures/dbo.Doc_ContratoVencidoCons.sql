SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Doc_ContratoVencidoCons]
@RucE char(11),
@NomUsu nvarchar(20),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	if not exists (select * from areaxusuario where RucE=@RucE and NomUsu=@NomUsu)
		set @msj='Usuario no Autorizado'
	else
		begin
			select con.RucE,con.Cd_Ctt,con.Cd_Clt,clt.RSocial AS NCliente,con.Cd_Prv,prv.RSocial AS NProveedor,con.Cd_Vdr,vdr.RSocial AS NVendedor,con.FecIni,con.FecFin,con.Descrip,con.Obs,con.FecReg,con.FecMdf,con.UsuCrea,con.UsuMdf,con.Cd_CC,con.Cd_SC,con.Cd_SS,cc.Descrip as Distrito, sc.Descrip as Edificio, ss.Descrip as Departamento
			from contrato con left join Cliente2 clt on (con.Cd_Clt = clt.Cd_Clt and con.RucE = clt.RucE)
							  left join Proveedor2 prv on (con.Cd_Prv = prv.Cd_Prv and con.RucE = prv.RucE)
							  left join Vendedor2 vdr on (con.Cd_Vdr = vdr.Cd_Vdr and con.RucE = vdr.RucE)
							  left join CCostos cc on (con.Cd_CC = cc.Cd_CC and con.RucE = cc.RucE)
							  left join CCSub sc on (con.Cd_SC = sc.Cd_SC and con.Cd_CC = sc.Cd_CC and con.RucE = sc.RucE)
							  left join CCSubSub ss on (con.Cd_SS = ss.Cd_SS and con.Cd_SC = ss.Cd_SC and con.Cd_CC = ss.Cd_CC and con.RucE = ss.RucE)
			where con.RucE=@RucE and datediff(d,getdate(),con.fecfin)<0 and datediff(d,getdate(),con.fecfin)>-31
		end
END
GO
