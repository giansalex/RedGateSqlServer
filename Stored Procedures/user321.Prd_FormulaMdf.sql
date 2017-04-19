SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormulaMdf]
@RucE nvarchar(11),
@ID_Fmla int,
@Cd_Prod char(10),
@ID_UMP int,
@Descrip varchar(200),
@Fecha datetime,
@Obs varchar(1000),
@IB_Prin bit,
@UsuMdf varchar(10),
@CA01 varchar(300),
@CA02 varchar(300),
@CA03 varchar(300),
@CA04 varchar(300),
@CA05 varchar(300),
@msj varchar(100) output
as
if not exists (select * from Formula where RucE=@RucE and ID_Fmla=@ID_Fmla)
	set @msj = 'Formula no existe'
else
begin
	if not exists(select * from Formula where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and ID_Fmla <> @ID_Fmla)
		set @IB_Prin = 1
	if(@IB_Prin = 1)
		update Formula set IB_Prin = 0 where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and ID_Fmla <> @ID_Fmla
	else		
		update top (1) Formula set IB_Prin = 1 where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and ID_Fmla <> @ID_Fmla
	update Formula set Cd_Prod=@Cd_Prod, ID_UMP=@ID_UMP, Descrip=@Descrip, Fecha=@Fecha, Obs=@Obs, IB_Prin=@IB_Prin,
		FecMdf=getdate(), UsuMdf=@UsuMdf,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05
	where RucE=@RucE and ID_Fmla=@ID_Fmla
	if @@rowcount <= 0
	   set @msj = 'Formula no pudo ser modificada'
end
print @msj
GO
