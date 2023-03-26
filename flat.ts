
type FlatListToHierarchicalConfigParams = {
    idKey: string;
    parentKey: string;
    childrenKey: string;
};


  function flatListToHierarchical (
      data: Record<string, any>[],
      {idKey='key',parentKey='parentId',childrenKey='children'} = {}
  ) {
      const tree: Record<string, any>[]  = [];
      data[0]
      const childrenOf = {};
      data.forEach((item) => {

          const newItem = {...item};
          const { [idKey]: id, [parentKey]: parentId = 0 } = newItem;
          childrenOf[id] = childrenOf[id] || [];
          newItem[childrenKey] = childrenOf[id];
          parentId
              ? (
                  childrenOf[parentId] = childrenOf[parentId] || []
              ).push(newItem)
              : tree.push(newItem);
      });
      return tree;
  };