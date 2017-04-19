CREATE TABLE [dbo].[Inventario]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Inv] [char] (12) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_TDES] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TO] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cant_Ing] [numeric] (13, 3) NULL,
[ID_UMBse] [int] NULL,
[Cant] [numeric] (13, 3) NOT NULL,
[CosUnt] [numeric] (15, 7) NULL,
[Total] [numeric] (15, 7) NULL,
[CosUnt_ME] [numeric] (15, 7) NULL,
[Total_ME] [numeric] (15, 7) NULL,
[IC_ES] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[SCant] [numeric] (13, 3) NULL,
[CProm] [numeric] (15, 7) NULL,
[SCT] [numeric] (15, 7) NULL,
[CProm_ME] [numeric] (15, 7) NULL,
[SCT_ME] [numeric] (15, 7) NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Item] [int] NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[NroGC] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_ProdGrp] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[CantGrp] [numeric] (13, 3) NULL,
[TipNC] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Lote] [char] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          TRIGGER [dbo].[trig_Inv_DeleteMov] ON [dbo].[Inventario]   
FOR DELETE   
AS  
  
declare @Cd_TDES char(2),  
@RucE nvarchar(11),  
@Cd_OC nvarchar(10),  
@Cd_OP nvarchar(10),  
@Cd_SR char(10),  
@Cd_OF char(10),  
@total_pend decimal(13,6),   
@totalcant decimal(13,6),  
@Cd_Inv char(12)  
  
select @Cd_TDES = Cd_TDES, @RucE = RucE, @Cd_OC = Cd_OC, @Cd_OP = Cd_OP, @Cd_SR = Cd_SR, @Cd_INV = Cd_Inv  
from Deleted   
  
if(@Cd_TDES = 'OC')  
begin  
 select @totalcant = sum(Cant) from OrdCompraDet c where c. RucE = @RucE and c.Cd_OC = @Cd_OC  
  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OC = c.Cd_OC and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC and c.Cd_Prod is not null) t  

 declare @Id_EstOC char(2)
 select @Id_EstOC = Id_EstOC from OrdCompra oc where oc.RucE = @RucE and oc.Cd_OC = @Cd_OC

  
 if(@total_pend = @totalcant)  
 begin  
   	if(@Id_EstOC = '02' or @Id_EstOC = '03')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,1,''
	if(@Id_EstOC = '05' or @Id_EstOC = '06')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,4,''
 end  
 else if(@total_pend > 0)  
 begin  
   	if(@Id_EstOC = '01' or @Id_EstOC = '03')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,2,''
	if(@Id_EstOC = '04' or @Id_EstOC = '06')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,5,''
 end  
 else if(@total_pend <= 0)  
 begin  
   	if(@Id_EstOC = '01' or @Id_EstOC = '02')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,3,''
	if(@Id_EstOC = '04' or @Id_EstOC = '05')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,6,''
 end  
 --print @total_pend  
end  
else if(@Cd_TDES = 'OP')  
begin  
 select @totalcant = sum(Cant) from OrdPedidoDet c where c. RucE = @RucE and c.Cd_OP = @Cd_OP  
  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OP = c.Cd_OP and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from OrdPedidoDet c where c.RucE = @RucE and c.Cd_OP = @Cd_OP and c.Cd_Prod is not null) t  
  
 if(@total_pend = @totalcant)  
 begin  
  exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,1,''  
 end  
 else if(@total_pend > 0)  
 begin  
   exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,2,''  
 end  
 else if(@total_pend <= 0)  
 begin  
    exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,3,''  
 end  
 --print @total_pend  
end  
else if(@Cd_TDES = 'SR')  
begin  
 select @totalcant = sum(Cant) from SolicitudReqDet c where c. RucE = @RucE and c.Cd_SR = @Cd_SR  
  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_SR = c.Cd_SR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR and c.Cd_Prod is not null) t  
  
 if(@total_pend = @totalcant)  
 begin  
  exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,1,''  
 end  
 else if(@total_pend > 0)  
 begin  
   exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,2,''  
 end  
 else if(@total_pend <= 0)  
 begin  
    exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,3,''  
 end  
 --print @total_pend  
end  
--Este parte de OF debe probarse bien. falta conversar los estados con pablo  
else if(@Cd_TDES = 'OF')  
begin  
 select @totalcant = sum(Cant) from SolicitudReqDet c where c. RucE = @RucE and c.Cd_SR = @Cd_SR  
  
 select @total_pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_SR = c.Cd_SR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente   
 from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR and c.Cd_Prod is not null) t  
  
 if(@total_pend >= @totalcant)  
 begin  
  exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,1,''  
 end  
end  
  
exec user321.Inv_Inventario_EliminaSeriales @RucE, @Cd_Inv, ''  
  
--CAM 26/01/11 <Creacion del Trigger>  
--CAM 27/01/11 <Actualizacion: Agregue OP>  
--CAM 28/01/11 <Actualizacion: Agregue OC>  
--CAM 28/02/11 <Actualizacion: se venia trabajando con un SP obsoleto. Se cambio a Inv_Inventario_EstadoUpd_3>  
--CAM 16/03/11 <Actualizacion: agrego el sp de eliminacion de seriales Linea 110>
--CAM 13/07/11 <Actualizacion: Se agrego mas estados a la tabla EstadoOC>
GO
ALTER TABLE [dbo].[Inventario] ADD CONSTRAINT [PK_Inventario] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Inv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_Compra] FOREIGN KEY ([RucE], [Cd_Com]) REFERENCES [dbo].[Compra] ([RucE], [Cd_Com])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_GuiaRemision] FOREIGN KEY ([RucE], [Cd_GR]) REFERENCES [dbo].[GuiaRemision] ([RucE], [Cd_GR])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_OrdCompra] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra] ([RucE], [Cd_OC])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_OrdPedido] FOREIGN KEY ([RucE], [Cd_OP]) REFERENCES [dbo].[OrdPedido] ([RucE], [Cd_OP])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_TipDoc] FOREIGN KEY ([Cd_TD]) REFERENCES [dbo].[TipDoc] ([Cd_TD])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_TipDocES] FOREIGN KEY ([RucE], [Cd_TDES]) REFERENCES [dbo].[TipDocES] ([RucE], [Cd_TDES])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_TipoOperacion] FOREIGN KEY ([Cd_TO]) REFERENCES [dbo].[TipoOperacion] ([Cd_TO])
GO
ALTER TABLE [dbo].[Inventario] WITH NOCHECK ADD CONSTRAINT [FK_Inventario_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cant de UM Base', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cant de UM Registrada', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cant_Ing'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cant de Grupo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'CantGrp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Gria de Remision de referencia', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_GR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Mtvo Ingreso/Salida', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_MIS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OC00000001', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_OC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_OF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Grupo Producto', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_ProdGrp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tip. Doc. Entrada/Salida', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Cd_TDES'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Costo Promedio', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'CProm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Costo Promedio', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'CProm_ME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UM Base', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'ID_UMBse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UM de Registro', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'ID_UMP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item OC/OP/GR', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Grupo Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'NroGC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo Cantidad', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'SCant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'SCT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'SCT_ME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Total'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'Inventario', 'COLUMN', N'Total_ME'
GO
