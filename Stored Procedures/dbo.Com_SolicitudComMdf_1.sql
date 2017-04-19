SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[Com_SolicitudComMdf_1] --Creacion de Solicitud de Compras
@RucE nvarchar(11),
@Cd_SCo char(10),
@NroSC varchar(15),
@FecEmi datetime,
@FecEntR datetime,
@Cd_FPC nvarchar(2),
@Asunto varchar(100),
@Cd_Area nvarchar(6),
@Obs varchar(1000),
@Elaboradopor varchar(100),
@Autorizadopor varchar(100),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@TipAut int,
@msj varchar(100) output
as
if not exists (select * from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo and NroSC = @NroSC)
	set @msj = 'No existe la Solicitud de Compra N°'+' '+@NroSC
else
begin
	--set @Cd_SC= user123.Cd_SC(@RucE)
	Update SolicitudCom set FecEmi=@FecEmi,FecEntR=@FecEntR,Cd_FPC=@Cd_FPC,Asunto=@Asunto,Cd_Area=@Cd_Area,
		     Obs=@Obs,ElaboradoPor=@Elaboradopor,
		     --AutorizadoPor=@Autorizadopor,
			FecMdf=@FecMdf,UsuMdf=@UsuMdf,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,
			Cd_SS = @Cd_SS,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05, TipAut = isnull(@TipAut,0)
		Where RucE=@RucE and Cd_SCo=@Cd_SCo and NroSC = @NroSC

	if @@rowcount <= 0
	set @msj = 'Solicitud de Compra no pudo ser modificada'	
end
GO
