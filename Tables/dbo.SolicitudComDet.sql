CREATE TABLE [dbo].[SolicitudComDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SRV] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cant] [numeric] (13, 3) NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AtSrv] [bit] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      TRIGGER [dbo].[trig_SolicitudComDet_DeleteMov] ON [dbo].[SolicitudComDet]   
FOR DELETE   
AS  
-- select * from SolicitudCom where RucE = '11111111111' and Cd_SR = 'SR00000029'  
-- select * from SolicitudComDet where RucE = '11111111111' --and Cd_SR = 'SR00000029'  
-- Pruebas:  
-- Com_VerificaPendientes_SolicitudReq '11111111111','SR00000029',''  
-- select RucE,Cd_SR,Id_EstSR from SolicitudReq where RucE = '11111111111' and Cd_SR = 'SR00000029'  
  
declare  
@RucE nvarchar(11),  
@Cd_SR char(10),  
@total_pend decimal(13,6),   
@totalcant decimal(13,6),  
@cd char(10),  
@Cd_SC char(10)  
  
select @RucE = RucE, @Cd_SC = Cd_SC from Deleted  
select @Cd_SR = sc.Cd_SR from SolicitudCom sc where RucE = @RucE and Cd_SCo = @Cd_SC  
  
if(@Cd_SR is not null)  
begin  
 --Calcula pendientes:  
 select @cd = Cd_SCo from SolicitudCom where RucE = @RucE and Cd_SR = @Cd_SR  
  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from SolicitudComDet i where i.RucE = c.RucE and i.Cd_SC = @cd and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR and c.Cd_Prod is not null) t  
 print @total_pend  
  
 --Calcula el total de productos de la SR:  
 select @totalcant = sum(Cant) from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR  
  
 if(@total_pend = @totalcant)  
 begin  
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,1,''  
 end  
 else if(@total_pend > 0)  
 begin  
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,2,''  
 end  
 else if(@total_pend <= 0)  
 begin  
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,3,''  
 end  
 --print @total_pend  
end  
  
--CAM 04/02/11 <Creacion del Trigger>
GO
ALTER TABLE [dbo].[SolicitudComDet] ADD CONSTRAINT [PK_SolicitudComDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SC], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudComDet] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudComDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[SolicitudComDet] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudComDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[SolicitudComDet] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudComDet_SolicitudCom] FOREIGN KEY ([RucE], [Cd_SC]) REFERENCES [dbo].[SolicitudCom] ([RucE], [Cd_SCo]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudComDet', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudComDet', 'COLUMN', N'Cd_SRV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudComDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para Servicios Atendidos', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudComDet', 'COLUMN', N'IB_AtSrv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudComDet', 'COLUMN', N'RucE'
GO
