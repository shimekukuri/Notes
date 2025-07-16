# React Design Patterns Navigation

## Abstract
The idea is making something that can be used like navigation in React native can, this pattern is good at having a
standard way of having a container that could switch between a few different components and you want to control there
props and when they are renedered this is a nice simple way of doing that. it also gives all of the typescript
intellesense


```typescript
import React, {
    ComponentType,
    Dispatch,
    ReactNode,
    SetStateAction,
    createContext,
    useContext,
    useEffect,
    useState,
} from "react";
import {
    ScrollView,
    StyleProp,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    ViewStyle,
} from "react-native";
import { blueSky, grey30 } from "@/components/colors";
import { baseStyles } from "@/useStyle";

export type TabNavigationProps<T, K extends keyof T> = T[K];

export interface TabRouterInterface<T, K extends keyof T = keyof T> {
    tabName: K | "";
    setTabName?: Dispatch<SetStateAction<keyof T>>;
    props?: T[K];
}

export interface TabNavigatorProps<T> {
    children: ReactNode;
    style?: StyleProp<ViewStyle>;
    disableBaseStyles?: boolean;
    initialRoute: Omit<TabRouterInterface<T>, "setTabName">;
    screen: keyof T | "" | undefined;
    setScreen: Dispatch<SetStateAction<keyof T | "">>;
}

export function createTabNavigator<T>() {
    function TabNavigator({
        children,
        style: x,
        disableBaseStyles = false,
        initialRoute,
        screen,
        setScreen,
    }: TabNavigatorProps<T>) {
        const [rendered, setRendered] = useState<boolean>(false);
        const names: Array<keyof T> = [];

        React.Children.forEach(children, (child) => {
            if (React.isValidElement<PageProps<T>>(child)) {
                names.push(child.props.name);
            }
        });

        useEffect(() => {
            if (!rendered) {
                setRendered((prev) => !prev);
                setScreen(initialRoute.tabName);
            }
        }, []);

        useEffect(() => {
            console.log("render");
        }, []);

        return (
            <MainContainer style={[x]} disableBaseStyles={disableBaseStyles}>
                <TabRouter
                    initialRoute={initialRoute}
                    screen={screen}
                    setScreen={setScreen}
                >
                    <AnimatedTabs names={names} />
                    {children}
                </TabRouter>
            </MainContainer>
        );
    }

    function MainContainer({
        children,
        style: x,
        disableBaseStyles,
    }: {
        children: ReactNode;
        style?: Array<StyleProp<ViewStyle>>;
        disableBaseStyles: boolean;
    }) {
        return (
            <View
                style={[
                    ...x,
                    disableBaseStyles ? {} : style.baseContainerStyles,
                ]}
            >
                {children}
            </View>
        );
    }

    function TabRouter({
        children,
        screen,
        setScreen,
        initialRoute,
    }: {
        children: ReactNode;
        screen: keyof T | "";
        setScreen: Dispatch<SetStateAction<keyof T>>;
        initialRoute: TabRouterInterface<T>;
    }) {
        return (
            <>
                <TabPageProvider
                    initialRoute={initialRoute}
                    screen={screen}
                    setScreen={setScreen}
                >
                    {children}
                </TabPageProvider>
            </>
        );
    }

    const TabRouterContext = createContext<TabRouterInterface<T>>({
        tabName: undefined,
        setTabName: undefined,
        props: undefined,
    });

    const TabPageProvider = ({
        children,
        initialRoute,
        screen,
        setScreen,
    }: {
        children: ReactNode;
        initialRoute: TabRouterInterface<T>;
        screen: keyof T | "";
        setScreen: Dispatch<SetStateAction<keyof T | "">>;
    }) => {
        return (
            <TabRouterContext.Provider
                value={{
                    tabName:
                        screen !== undefined ? screen : initialRoute.tabName,
                    setTabName: setScreen,
                    props: undefined,
                }}
            >
                {children}
            </TabRouterContext.Provider>
        );
    };

    interface PageProps<T, K extends keyof T = keyof T> {
        Component: ComponentType<T[K]>;
        name: K;
        props?: T[K];
    }

    const Page = <K extends keyof T>({
        Component,
        name,
        props,
    }: PageProps<T, K>) => {
        const { tabName, props: contextProp } = useContext(TabRouterContext);

        return (
            <>
                {tabName === name ? (
                    <Component {...props} {...contextProp} />
                ) : (
                    ""
                )}
            </>
        );
    };

    const AnimatedTabs = ({ names }: { names: Array<keyof T> }) => {
        const { tabName, setTabName } =
            useContext<TabRouterInterface<T>>(TabRouterContext);

        return (
            <View
                style={{
                    paddingVertical: 6,
                    borderBottomWidth: 1,
                    borderColor: grey30,
                }}
            >
                <ScrollView
                    horizontal={true}
                    showsHorizontalScrollIndicator={false}
                    style={{ paddingHorizontal: 0 }}
                    contentContainerStyle={{ alignItems: "center", gap: 10 }}
                >
                    {names.map((x) => {
                        return (
                            <AnimatedTab
                                active={tabName.toString() === x.toString()}
                                title={x.toString()}
                                onPress={() => setTabName(x)}
                            />
                        );
                    })}
                </ScrollView>
            </View>
        );
    };

    const AnimatedTab = ({
        active,
        title,
        onPress,
    }: {
        active: boolean;
        title: string;
        onPress: () => void;
    }) => {
        return (
            <TouchableOpacity onPress={onPress}>
                <View
                    style={{
                        ...style.tab,
                        ...{ ...(active && style.active) },
                    }}
                >
                    <Text style={style.tabText}>{title}</Text>
                </View>
            </TouchableOpacity>
        );
    };

    return {
        Page: Page,
        Navigator: TabNavigator,
    };
}

const style = StyleSheet.create({
    baseContainerStyles: {
        display: "flex",
        height: "100%",
    },
    tab: {
        alignItems: "center",
        padding: 10,
    },
    active: {
        borderBottomWidth: 2,
        borderColor: blueSky,
    },
    tabText: {
        ...baseStyles.fontStyle,
        fontSize: 18,
    },
});

```

example usage:

```typescript
import React, { useEffect, useState } from "react";
import { ActivityIndicator, View } from "react-native";
import { NativeStackScreenProps } from "@react-navigation/native-stack";

import { createTabNavigator } from "@/components/Tabs/TabNavigator/TabNavigator";
import { RootStackParamList } from "@/App";
import { claytonBlue } from "@/components/colors";
import { ErrorModal } from "@/components/Modals/ErrorModal";

import { ConditionReportTab } from "../ConditionReport/ConditionReportTab/ConditionReportTab";
import { AssetDetailsTab } from "../AssetDetails/AssetDetailsTab/AssetDetailsTab";
import { AssetHeader } from "./components/AssetHeader";
import { NotesTab } from "../Notes/NotesTab/NotesTab";
import { TasksTab } from "../Tasks/TasksTab";
import { useAsset } from "./api/useAsset";
import { MediaTab } from "../Media/MediaTab/MediaTab";

type AssetProps = NativeStackScreenProps<RootStackParamList, "Asset">;

export type AssetTabProps = {
    Details: { id: string };
    Media: { id: string };
    Notes: { accountId?: string };
    Condition: { id: string };
    Tasks: { id: string };
};

const Tab = createTabNavigator<AssetTabProps>();

export const Asset = ({ navigation, route }: AssetProps) => {
    const id = route.params.id;
    const {
        data: asset,
        isLoading,
        isError,
        errorStatus,
        refetch,
    } = useAsset(id);

    const [screen, setScreen] = useState<keyof AssetTabProps | "">("");

    const [errorModalShown, setErrorModalShown] = useState<boolean>(false);

    useEffect(() => {
        if (isError) {
            setErrorModalShown(true);
        }
    }, [isError]);

    if (isError) {
        return (
            <ErrorModal
                onRefreshError={() => {
                    setScreen("");
                    setErrorModalShown(false);
                    navigation.navigate("auth");
                }}
                setModalVisible={setErrorModalShown}
                message="Something went wrong"
                callback={() => refetch()}
                modalVisible={errorModalShown}
                status={errorStatus}
            />
        );
    }
    if (isLoading) {
        return (
            <View
                style={{
                    paddingTop: 20,
                    justifyContent: "center",
                    alignItems: "center",
                }}
            >
                <ActivityIndicator color={claytonBlue} size="large" />
            </View>
        );
    }

    return (
        <View
            style={{
                display: "flex",
                flex: 1,
                backgroundColor: "white",
            }}
        >
            <AssetHeader
                asset={asset}
                id={id}
                navigation={navigation}
                setSelectedTab={() => setScreen("Details")}
            />
            <Tab.Navigator
                screen={screen}
                setScreen={setScreen}
                initialRoute={{
                    tabName: "Media",
                    props: { id },
                }}
            >
                <Tab.Page
                    name="Details"
                    props={{ id }}
                    Component={AssetDetailsTab}
                />
                <Tab.Page name="Media" props={{ id }} Component={MediaTab} />
                <Tab.Page
                    name="Notes"
                    props={{ accountId: asset.accountId }}
                    Component={NotesTab}
                />
                <Tab.Page
                    name="Condition"
                    props={{ id }}
                    Component={ConditionReportTab}
                />
                <Tab.Page name="Tasks" props={{ id }} Component={TasksTab} />
            </Tab.Navigator>
        </View>
    );
};

```

## Directory

## Useful Links

## Tags
[[react-design-patterns]]
