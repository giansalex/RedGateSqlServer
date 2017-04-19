SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [user321].[Prd_FormulaCrea]
@RucE nvarchar(11),
@ID_Fmla int output,
@Cd_Prod char(10),
@ID_UMP int,
@Descrip varchar(200),
@Fecha datetime,
@Obs varchar(1000),
@IB_Prin bit,
@UsuCrea varchar(10),
@CA01 varchar(300),
@CA02 varchar(300),
@CA03 varchar(300),
@CA04 varchar(300),
@CA05 varchar(300),
@CA06 varchar(300),
@CA07 varchar(300),
@CA08 varchar(300),
@CA09 varchar(300),
@CA10 varchar(300),
@CA11 varchar(300),
@CA12 varchar(300),
@CA13 varchar(300),
@CA14 varchar(300),
@CA15 varchar(300),
@msj varchar(100) output

as
Set @ID_Fmla = dbo.ID_Fmla(@RucE)

if exists (select * from Formula where RucE=@RucE and ID_Fmla=@ID_Fmla)
	Set @msj = 'Esta Formula ya ha sido registrada' 

else
begin
	if not exists(select * from Formula where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP)
		set @IB_Prin = 1
	if(@IB_Prin = 1)
		update Formula set IB_Prin = 0 where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	insert into Formula(RucE,ID_Fmla,Cd_Prod,ID_UMP,Descrip,Fecha,Obs,IB_Prin,FecReg,FecMdf,UsuCrea,UsuMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15)
			values(@RucE,@ID_Fmla,@Cd_Prod,@ID_UMP,@Descrip,@Fecha,@Obs,@IB_Prin,GETDATE(),null,@UsuCrea,null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar Formula'

end
-- Leyenda --
-- FL : 2011-02-04 : <Creacion del procedimiento almacenado>
-- CE : 03-09-2012 : <Modf: Se agregaron campos adicionales>



--select * from Formula where RucE = '11111111111' and Cd_Prod = 'PD00052'
GO
